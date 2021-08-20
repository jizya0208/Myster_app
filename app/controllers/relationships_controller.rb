class RelationshipsController < ApplicationController
  before_action :set_member
  # ——————--フォロー関係を作成・削除する————————————-----
  def create
    current_member.follow(params[:member_id]) # followメソッドの引数にはActiveRecordの仕様(便利機能)により生成された仮想的な属性member_idを入れる
    @member.create_notification_follow!(current_member)
  end

  def destroy
    current_member.unfollow(params[:member_id]) # unfollowメソッドの引数にはActiveRecordの仕様(便利機能)により生成された仮想的な属性member_idを入れる
  end

  # ————————フォロー・フォロワー一覧を表示する-————————————
  def followings
    @members = @member.followings  # member.rbでリレーションを組成
  end

  def followers
    @members = @member.followers   # member.rbでリレーションを組成
  end

  private

  def set_member
    @member = Member.find(params[:member_id])
  end

end
