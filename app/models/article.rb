class Article < ApplicationRecord
  belongs_to :member
  belongs_to :category
  has_many :article_images, dependent: :destroy
  has_many :article_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :tag_maps, dependent: :destroy
  has_many :tags, through: :tag_maps                              #投稿テーブルは中間テーブル(tag_maps)を通じて複数のタグを持つ
  has_many :notifications, dependent: :destroy

  accepts_attachments_for :article_images, attachment: :image

  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }

  after_create do                                                 # ActiveRecordのコールバック。DBへのコミット直前に実施する。
    article = Article.find_by(id: self.id)                        # /は正規表現のデリミタとして慣習的に用いられる。 角括弧は、指定した複数の文字からいずれか一文字にマッチさせる役割  [#＃] => ハッシュ記号を取得
    tags = self.body.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)          # \w => アルファベット、アンダーバー、数字(定義済の正規表現)  \p{Han} => 漢字  ぁ-ヶ=> 全角ひらがな〜全角カタカナ ｦ-ﾟ => 半角カタカナ、ー => 伸ばし棒
    article.tags = []                                             #  + => 最長一致(文の左側から探し始め、目的の文字が見つかっても、行けるところまで進む) scan は正規表現のパターンからマッチした文字列を取得していき、配列として返す役割。
    tags.uniq.map do |tag|                                        # uniqメソッドは重複している要素を削除した上で配列を返す役割
      tag = Tag.find_or_create_by(name: tag.downcase.delete('#')) # ハッシュタグは先頭の'#'を外した上で保存
      article.tags << tag
    end
  end

  def favorited_by?(member)                                       # 既にお気に入り済みか真偽値で返すメソッド
    favorites.where(member_id: member.id).exists?
  end

  def Article.filter_by_category(category)                        # カテゴリーで投稿を絞り込むためのメソッド
    Article.where(category_id: category)
  end

  def create_notification_favorite!(current_member)                   # お気に入りに対する通知を生成するメソッド
    temp = Notification.find_by(["visitor_id = ? and visited_id = ? and article_id = ? and action = ? ", current_member.id, member_id, id, 'favorite'])  #すでに「いいね」されているか検索
    if temp.blank?                                                  # 既にお気に入りされていない場合のみ、通知レコードを作成
      notification = current_member.active_notifications.new(
        article_id: id,
        visited_id: member_id,
        action: 'like'
      )
      if notification.visitor_id == notification.visited_id       # 自分の投稿へのお気に入りは通知不要としたいので、ステータスを確認済する。
        notification.is_checked = true
      end
      notification.save if notification.valid?
    end
  end

  def create_notification_comment!(current_member, article_comment_id) #コメントに対する通知を生成するメソッド。期待する挙動：同じ投稿にコメントしているユーザーに通知を送る。
    temp_ids = ArticleComment.select(:member_id).where(article_id: id).where.not(member_id: current_member.id).distinct  #投稿にコメントしている自分以外のユーザーを重複なし(=>distinct)でリスト化。
    temp_ids.each do |temp_id|                                         #取得したユーザー達へ通知を作成。（member_idのみ繰り返し取得）
      save_notification_comment!(current_member, article_comment_id, temp_id['member_id'])
    end
    save_notification_comment!(current_member, article_comment_id, member_id) if temp_ids.blank? # まだ誰もコメントしていない場合は、投稿者に通知を送る
  end

  def save_notification_comment!(current_member, article_comment_id, visited_id) # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_member.active_notifications.new( #visitor_id == current_member
      article_id: id,                                      #メソッドを呼び出した投稿データのID
      article_comment_id: article_comment_id,              
      visited_id: visited_id,
      action: 'comment'
    )
    if notification.visitor_id == notification.visited_id  # 自分の投稿へのコメントは通知不要としたいので、ステータスを確認済する。
      notification.checked = true
    end
    notification.save if notification.valid?
  end

  scope :search, -> ( keyword ) {     #検索機能用。クラスメソッドを使う際に可読性を保つために定義。
    where("title LIKE :q OR body LIKE :q ", q: "%#{keyword}%") if keyword.present?
  }
end