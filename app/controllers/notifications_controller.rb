class NotificationsController < ApplicationController
  def index
    @notifications = current_member.passive_notifications
    @notifications.where(is_checked: false).each do |notification| #通知画面を開くとcheckedをtrueにして通知確認済にする
      notification.update_attributes(is_checked: true)
    end
  end
end
