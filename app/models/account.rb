class Account < ApplicationRecord
  belongs_to :member
  has_many :account_histories
  #残高は0ポイント以上
  validates :balance, numericality: {greater_than_or_equal_to: 0}
end
