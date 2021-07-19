class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer :visitor_id, null: false
      t.integer :visited_id, null: false
      t.integer :article_id
      t.integer :article_commemt_id
      t.string :action, default: '', null: false
      t.boolean :is_checked, default: false, null: false

      t.timestamps
    end
  end
end
