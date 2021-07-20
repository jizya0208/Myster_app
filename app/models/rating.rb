class Rating < ApplicationRecord
  belongs_to :member
  belongs_to :article_comment

  validates :rate, numericality: {
    less_than_or_equal_to: 5,
    greater_than_or_equal_to: 1
  }, presence: true
end
