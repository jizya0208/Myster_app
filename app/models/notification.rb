class Notification < ApplicationRecord
  default_scope -> { order(created_at: :desc) } #作成日を降順でソートすることで、新しい通知から順に並ぶ
  belongs_to :article, optional: true  #belongs_toの紐付けによりデフォルトでnilは許可されないが、optional: trueで、nilを許容
  belongs_to :article_comments, optional: true
  belongs_to :visitor, class_name: 'Member', foreign_key: 'visitor_id'
  belongs_to :visited, class_name: 'Member', foreign_key: 'visited_id'


  def create_notification_like!(current_member) #お気に入りに対する通知を生成するメソッド
    temp = Notification.where(["visitor_id = ? and visited_id = ? and article_id = ? and action = ? ", current_member.id, member_id, id, 'like'])  #すでに「いいね」されているか検索
    unless temp # 既にお気に入りされていない場合のみ、通知レコードを作成
      notification = current_member.active_notifications.new(
        article_id: id,
        visited_id: member_id,
        action: 'like'
      )
      if notification.visitor_id == notification.visited_id  # 自分の投稿へのお気に入りは通知不要としたいので、ステータスを確認済する。
        notification.is_checked = true
      end
      notification.save if notification.valid?
    end
  end
end
