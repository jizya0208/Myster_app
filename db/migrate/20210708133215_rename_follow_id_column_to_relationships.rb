class RenameFollowIdColumnToRelationships < ActiveRecord::Migration[5.2]
  def change
    rename_column :relationships, :follow_id, :follower_id
  end
end
