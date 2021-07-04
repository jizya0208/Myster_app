class Article < ApplicationRecord
  belongs_to :member
  belongs_to :category
  has_many :article_comments
  has_many :favorites
  
  attachment :image
  
  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }
end