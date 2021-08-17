class AddParentToArticleComments < ActiveRecord::Migration[5.2]
  def change
    add_reference :article_comments, :parent, foreign_key: { to_table: :article_comments }
  end
end
