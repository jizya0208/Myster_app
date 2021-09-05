class AddFavoritesCountToArticles < ActiveRecord::Migration[5.2]
  def self.up
    add_column :articles, :favorites_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :articles, :favorites_count
  end
end
