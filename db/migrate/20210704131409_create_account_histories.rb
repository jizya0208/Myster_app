class CreateAccountHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :account_histories do |t|
      t.integer :transaction_id
      t.integer :transaction_type_id
      t.integer :account_id
      t.integer :amount
      t.integer :balance
      t.string :remark

      t.timestamps
    end
  end
end
