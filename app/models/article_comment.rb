class ArticleComment < ApplicationRecord
  belongs_to :member
  belongs_to :article
  has_many :ratings

  attachment :image

  validates :body, presence: true, length: { maximum: 200 }
end
