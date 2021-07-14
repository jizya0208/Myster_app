class CreateTransactionNumbers < ActiveRecord::Migration[5.2]
  def change
    create_table :transaction_numbers do |t|

      t.timestamps
    end
  end
end
