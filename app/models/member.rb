class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :account
  has_many :articles
  has_many :favorites
  has_many :favorite_articles, through: :favorites, source: :article
  has_many :article_comments
  has_many :ratings
  #与フォロー関係をrelationships・被フォロー関係をpassive_relationshipsと便宜上命名する。class_name: "Relationship"で、いずれも参照するのはRelationshipモデルであることを補足。
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed  #与フォロー関係(relationships)を通じて被フォローモデル(followed)を参照(source)すると、ユーザが持つフォローユーザ一覧(followings)を取得できる。
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower #被フォロー関係(passive_relationships)を通じて与フォローモデル(follower)を参照(source)すると、ユーザが持つフォロワー一覧(followers)を取得できる

  enum gender: {男性: 0, 女性: 1}
  attachment :image

  validates :name, presence: true, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 150 }

  def follow(other_member)
    unless self == other_member
      relationships.create(followed_id: other_member)  #与フォロー時のデータ生成メソッド
    end
  end
  def unfollow(other_member)
    unless self == other_member
      relationships.find_by(followed_id: other_member).destroy  #フォロー解除時のデータ削除メソッド
    end
  end
  def following?(other_member)
    self.followings.include?(other_member)   #既にフォロー済みかを真偽値で返すメソッド
  end
end


