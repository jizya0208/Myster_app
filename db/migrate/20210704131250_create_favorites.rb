class CreateFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :favorites do |t|
      t.integer :article_id
      t.integer :member_id

      t.timestamps
    end
  end
end
