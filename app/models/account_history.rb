class AccountHistory < ApplicationRecord
  belongs_to :account
  belongs_to :transaction_number
  belongs_to :transaction_type

  validates :amount, presence: true
  validates :remark, presence: true
  #残高は0ポイント以上、取引は1ポイント以上
  validates :balance, numericality: {greater_than_or_equal_to: 0}
  validates :amount, numericality: {greater_than_or_equal_to: 1}
end
