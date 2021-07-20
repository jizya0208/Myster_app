class TransactionNumber < ApplicationRecord
  has_many :account_histories
end
