class ArticleComment < ApplicationRecord
  belongs_to :member
  belongs_to :article
  belongs_to :parent, class_name: "ArticleComment", optional: true # 自己の親コメントをparentと名付け、class_nameでコメントテーブル参照を指定。返信コメントでない通常コメントも保存したいので optional: true とし、nilを許容。(Rails5ではデフォルト required: trueとなっている)
  has_many :ratings
  has_many :notifications, dependent: :destroy
  has_many :replies, class_name: "ArticleComment", foreign_key: :parent_id # 自己の子供をreplyと名付け、class_name, foreign_keyとともに記述。上記の:parentと合わせて自己結合関連付けが出来る。

  attachment :image

  validates :body, presence: true, length: { maximum: 300 }

  # 既に評価済みか真偽値で返すメソッド
  def rated_by?(member)
    ratings.where(member_id: member.id).exists?
  end
  
  scope :original, -> { where(parent_id: nil) }
end
