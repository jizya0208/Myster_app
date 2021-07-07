class RemoveColumnInArticles < ActiveRecord::Migration[5.2]
  def change
    remove_column :articles, :image_id, :string 
  end
end
