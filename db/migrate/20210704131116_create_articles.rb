class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.integer :member_id
      t.string :title
      t.text :body
      t.string :image_id
      t.integer :category_id
      t.boolean :is_closed

      t.timestamps
    end
  end
end
