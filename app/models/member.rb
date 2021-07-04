class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :account
  has_many :articles
  has_many :favorite_articles, through: :favorites, source: :article
  has_many :favorites
  has_many :article_comments
  has_many :ratings

  enum gender: {男性: 0, 女性: 1}
  attachment :image

  validates :name, presence: true, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 150 }
  validates :is_delected, presence: true

end
