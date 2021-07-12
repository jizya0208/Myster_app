class CreateTagMaps < ActiveRecord::Migration[5.2]
  def change
    create_table :tag_maps do |t|
      t.integer :tag_id
      t.integer :article_id

      t.timestamps
    end
  end
end
