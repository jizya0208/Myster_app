class Article < ApplicationRecord
  belongs_to :member
  belongs_to :category
  has_many :article_images, dependent: :destroy
  has_many :article_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  accepts_attachments_for :article_images, attachment: :image

  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }
  
  
  # 既にお気に入り済みか真偽値で返すメソッド
  def favorited_by?(member)
    favorites.where(member_id: member.id).exists?
  end
end