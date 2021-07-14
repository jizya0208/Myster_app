class Article < ApplicationRecord
  belongs_to :member
  belongs_to :category
  has_many :article_images, dependent: :destroy
  has_many :article_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :tag_maps, dependent: :destroy
  has_many :tags, through: :tag_maps #投稿テーブルは中間テーブル(tag_maps)を通じて複数のタグを持つ

  accepts_attachments_for :article_images, attachment: :image

  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }

  after_create do #ActiveRecordのコールバック。DBへのコミット直前に実施する。
    article = Article.find_by(id: self.id)
    tags  = self.body.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)   #は正規表現のデリミタとして慣習的に用いられる
                                                            #  角括弧は、指定した複数の文字からいずれか一文字にマッチさせる役割  [#＃] => ハッシュ記号を取得
                                                            #  \w => アルファベット、アンダーバー、数字(定義済の正規表現)  \p{Han} => 漢字  ぁ-ヶ=> 全角ひらがな〜全角カタカナ ｦ-ﾟ => 半角カタカナ、ー => 伸ばし棒
                                                            #  + => 最長一致(文の左側から探し始め、目的の文字が見つかっても、行けるところまで進む)
                                                            #  scan は正規表現のパターンからマッチした文字列を取得していき、配列として返す役割。
    article.tags = []
    tags.uniq.map do |tag|                                        # uniqメソッドは重複している要素を削除した上で配列を返す役割
      tag = Tag.find_or_create_by(name: tag.downcase.delete('#')) #ハッシュタグは先頭の'#'を外した上で保存
      article.tags << tag
    end
  end

  # 既にお気に入り済みか真偽値で返すメソッド
  def favorited_by?(member)
    favorites.where(member_id: member.id).exists?
  end

  def Article.filter_by_category(category)
    Article.where(category_id: category)
  end
end