class Article < ApplicationRecord
  belongs_to :member
  belongs_to :category
  has_many :article_images, dependent: :destroy
  has_many :article_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :tag_maps, dependent: :destroy
  has_many :tags, through: :tag_maps                              # 投稿テーブルは中間テーブル(tag_maps)を通じて複数のタグを持つ
  has_many :notifications, dependent: :destroy

  accepts_attachments_for :article_images, attachment: :image

  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 400 }

  after_create do                                                 # ActiveRecordのコールバック。DBへのコミット直前に実施する。
    article = Article.find_by(id: id) # /は正規表現のデリミタとして慣習的に用いられる。 角括弧は、指定した複数の文字からいずれか一文字にマッチさせる役割  [#＃] => ハッシュ記号を取得
    tags = body.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/) # \w => アルファベット、アンダーバー、数字(定義済の正規表現)  \p{Han} => 漢字  ぁ-ヶ=> 全角ひらがな〜全角カタカナ ｦ-ﾟ => 半角カタカナ、ー => 伸ばし棒
    article.tags = []                                             #  + => 最長一致(文の左側から探し始め、目的の文字が見つかっても、行けるところまで進む) scan は正規表現のパターンからマッチした文字列を取得していき、配列として返す役割。
    tags.uniq.map do |tag|                                        # uniqメソッドは重複している要素を削除した上で配列を返す役割
      tag = Tag.find_or_create_by(name: tag.downcase.delete('#')) # ハッシュタグは先頭の'#'を外した上で保存
      article.tags << tag
    end
  end

  # 既にお気に入り済みか真偽値で返すメソッド
  def favorited_by?(member)
    favorites.where(member_id: member.id).exists?
  end

  # カテゴリーで投稿を絞り込むためのメソッド
  def self.filter_by_category(category)
    Article.where(category_id: category)
  end

  # お気に入りに対する通知を生成するメソッド
  def create_notification_favorite!(current_member)
    temp = Notification.where(['visitor_id = ? and visited_id = ? and article_id = ? and action = ? ', current_member.id, member_id, id, 'favorite']) # すでに「いいね」されているか検索
    if temp.blank?                                                # 既にお気に入りされていない場合のみ、通知レコードを作成
      notification = current_member.active_notifications.new(
        article_id: id,
        visited_id: member_id,
        action: 'favorite'
      )
      if notification.visitor_id == notification.visited_id       # 自分の投稿へのお気に入りは通知不要としたいので、生成時からステータスは確認済とする。
        notification.is_checked = true
      end
      notification.save if notification.valid?
    end
  end

  # コメントに対する通知を生成するメソッド。期待する挙動：同じ投稿にコメントしているユーザーに通知を送る。
  def create_notification_comment!(current_member, article_comment_id) # !を付けているのはメソッド内でデータ登録をおこなうので呼び出し時に注意喚起をするため
    temp_ids = ArticleComment.select(:member_id).where(article_id: id).where.not(member_id: current_member.id).distinct # 投稿にコメントしている自分以外のユーザーを重複なし(=>distinct)でリスト化。
    temp_ids.each do |temp_id| # 取得したユーザー達へ通知を作成。（member_idのみ繰り返し取得）
      save_notification_comment!(current_member, article_comment_id, temp_id['member_id'])
    end
    save_notification_comment!(current_member, article_comment_id, member_id) if temp_ids.blank?
  end

  # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
  def save_notification_comment!(current_member, article_comment_id, visited_id)
    notification = current_member.active_notifications.new( # visitor_id == current_member
      article_id: id,                                      # メソッドを呼び出した投稿データのID
      article_comment_id: article_comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    if notification.visitor_id == notification.visited_id  # 自分の投稿へのコメントは通知不要としたいので、ステータスを確認済する。
      notification.is_checked = true
    end
    notification.save if notification.valid?
  end

  def self.search_for(category, sort_method)
    if category.blank? 
      case sort_method
      when "created_at_ASC"
        self.order(created_at: 'ASC')
      when "comment_ASC"
        self.comment_asc
      when "favorite_DESC"
        self.favorite_desc
      else
        self.all
      end
    else
      case sort_method
      when "created_at_ASC"
        self.where(category_id: category).order(created_at: 'ASC')
      when "comment_ASC"
        self.where(category_id: category).comment_asc
      when "favorite_DESC"
        self.where(category_id: category).favorite_desc
      else
        self.where(category_id: category)
      end
    end
  end

  # scope :スコープ名, -> (引数) { 条件式 }
  scope :search, lambda { |keyword|     # 検索機能用。クラスメソッドを使う際に可読性を保つために定義。
    where('title LIKE :q ', q: "%#{keyword}%") if keyword.present?
  }
  scope :recent, -> (count) { where(is_closed: nil).order(created_at: 'DESC').limit(count) }
  scope :shares, -> { preload([:member, :article_images]).where(is_closed: nil).order(created_at: 'DESC') }
  scope :questions, -> { preload([:member, :article_images]).where(is_closed: false).order(created_at: 'DESC') }
  scope :comment_asc, -> { sort_by{|article| article.article_comments_count} }
  scope :favorite_desc, -> { sort_by{|article| article.favorites_count}.reverse }
end

