class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :account
  has_many :articles
  has_many :article_comments
  has_many :favorites
  has_many :favorite_articles, through: :favorites, source: :article
  has_many :ratings
  has_many :relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy # 与フォロー関係をrelationships・被フォロー関係をpassive_relationshipsと便宜上命名する。class_name: "Relationship"で、いずれも参照するのはRelationshipモデルであることを補足。
  has_many :followings, through: :relationships, source: :followed # 与フォロー関係(relationships)を通じて被フォローモデル(followed)を参照(source)すると、ユーザが持つフォローユーザ一覧(followings)を取得できる。
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower # 被フォロー関係(passive_relationships)を通じて与フォローモデル(follower)を参照(source)すると、ユーザが持つフォロワー一覧(followers)を取得できる
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy # 紐付ける名前とクラス名が異なるため、明示的にクラス名とIDを指定して紐付ける
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy # 与通知ユーザ => actiove_notification    被通知ユーザ => passive_notification

  enum gender: { 男性: 0, 女性: 1 }
  attachment :image

  validates :name, presence: true, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 150 }

  def follow(other_member)
    unless self == other_member
      relationships.create(followed_id: other_member) # 与フォロー時のデータ生成メソッド
    end
  end

  def unfollow(other_member)
    unless self == other_member
      relationships.find_by(followed_id: other_member).destroy # フォロー解除時のデータ削除メソッド
    end
  end

  def following?(other_member)
    followings.include?(other_member) # 既にフォロー済みかを真偽値で返すメソッド
  end

  # deviseメソッド：退会（論理削除）後のログイン
  # sessionコントローラーをオーバーライドする。(superを記述することで、継承元の機能は失われずに追加の機能を実装することが可能)
  def active_for_authentication?
    super && (is_deleted == false) # superはオーバーライドで用いられる。
  end

  def inactive_message
    '退会済みのアカウントです。'
  end

  # 年齢を世代ごとに区分し、性別と合わせて変換するメソッド。modelで定義する際は、selfや引数のカラムは省略可能。
  def classify
    case age
      when age = 10..14 then "10代前半#{gender}"
      when age = 15..19 then "10代後半#{gender}"
      when age = 20..24 then "20代前半#{gender}"
      when age = 25..29 then "20代後半#{gender}"
      when age = 30..34 then "30代前半#{gender}"
      when age = 35..39 then "30代後半#{gender}"
      when age = 40..44 then "40代前半#{gender}"
      when age = 45..49 then "40代後半#{gender}"
      when age = 50..54 then "50代前半#{gender}"
      when age = 55..59 then "50代後半#{gender}"
      when age = 60..100 then "60歳以上#{gender}"
      else "年齢非公開#{gender}"
    end
  end

  # フォロー時の通知を生成するメソッド
  def create_notification_follow!(current_member)
    temp = Notification.where(['visitor_id = ? and visited_id = ? and action = ? ', current_member.id, id, 'follow'])
    if temp.blank?
      notification = current_member.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |member|
      member.name = "ゲストユーザ"
      member.password = SecureRandom.urlsafe_base64 # ランダムで URL-safe な base64 文字列を生成し、パスワードに入れる
    end
  end
end
