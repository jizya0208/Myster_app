class Account < ApplicationRecord
  belongs_to :member
  has_many :account_histories

  validates :balance, numericality: { greater_than_or_equal_to: 0 } # 残高は必ず0ポイント以上
end
