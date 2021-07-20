class NotificationsController < ApplicationController
  def index
    @notifications = current_member.passive_notifications
    @notifications.where(is_checked: false).each do |notification| #通知画面を開くとcheckedをtrueにして通知確認済にする
      notification.update_attributes(is_checked: true)
    end
  end
  
  def destroy_all #通知を全削除
    @notifications = current_member.passive_notifications.destroy_all
    redirect_to request.referer
  end
end
