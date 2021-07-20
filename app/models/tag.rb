class Tag < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: { maximum: 20 }
  has_many :tag_maps
  has_many :articles, through: :tag_maps   # タグテーブルは中間テーブル(tag_maps)を通じて複数の投稿を持つ
end
