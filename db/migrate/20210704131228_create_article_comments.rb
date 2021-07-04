class CreateArticleComments < ActiveRecord::Migration[5.2]
  def change
    create_table :article_comments do |t|
      t.integer :article_id
      t.integer :member_id
      t.text :body
      t.string :image_id

      t.timestamps
    end
  end
end
