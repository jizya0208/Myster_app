class RenameTransactionIdColumnToAccountHistories < ActiveRecord::Migration[5.2]
  def change
    rename_column :account_histories, :transaction_id, :transaction_number_id
  end
end
