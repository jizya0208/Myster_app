class NotificationsController < ApplicationController
  before_action :authenticate_member!
  def index
    @notifications = current_member.passive_notifications.preload([:visitor]).where.not(visitor_id: current_member.id)
    # 通知画面を開くとcheckedをtrueにして通知確認済にする
    @notifications.where(is_checked: false).update_all(is_checked: true)
  end

  # 通知を全削除
  def destroy_all
    @notifications = current_member.passive_notifications.destroy_all
    redirect_to request.referer
  end
end
