class CreateRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :ratings do |t|
      t.integer :article_comment_id
      t.integer :member_id
      t.float :rate, null: false, default: 0

      t.timestamps
    end
  end
end
