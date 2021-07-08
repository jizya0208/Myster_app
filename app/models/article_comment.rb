class ArticleComment < ApplicationRecord
  belongs_to :member
  belongs_to :article
  has_many :ratings

  attachment :image

  validates :body, presence: true, length: { maximum: 200 }

  # 既に評価済みか真偽値で返すメソッド
  def rated_by?(member)
    ratings.where(member_id: member.id).exists?
  end
end
