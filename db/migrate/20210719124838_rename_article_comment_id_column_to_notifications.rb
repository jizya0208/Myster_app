class RenameArticleCommentIdColumnToNotifications < ActiveRecord::Migration[5.2]
  def change
   rename_column :notifications, :article_commemt_id, :article_comment_id
  end
end
