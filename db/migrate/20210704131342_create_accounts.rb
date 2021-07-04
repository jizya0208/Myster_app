class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.integer :member_id
      t.integer :balance, default: 0

      t.timestamps
    end
  end
end
