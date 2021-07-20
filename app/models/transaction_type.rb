class TransactionType < ApplicationRecord
  has_many :account_histories

  enum name: { 支払: 0, 受取: 1, チャージ: 2 }

  validates :name, presence: true
end
