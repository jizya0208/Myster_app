class RelationshipsController < ApplicationController
  # ——————--フォロー関係を作成・削除する————————————-----
  def create
    current_member.follow(params[:member_id])   #followメソッドの引数にはActiveRecordの仕様(便利機能)により生成された仮想的な属性user_idを入れる
    redirect_to request.referer
  end

  def destroy
    current_member.unfollow(params[:member_id])  #unfollowメソッドの引数にはActiveRecordの仕様(便利機能)により生成された仮想的な属性user_idを入れる
    redirect_to request.referer
  end

  #————————フォロー・フォロワー一覧を表示する-————————————
  def followings
    member = Member.find(params[:member_id])
    @members = member.followings   #member.rbで定義済
  end

  def followers
    member = Member.find(params[:member_id])
    @members = member.followers   #member.rbで定義済
  end
end
