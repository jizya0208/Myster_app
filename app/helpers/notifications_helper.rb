module NotificationsHelper
  # アクションに応じて通知メッセージを返すヘルパーメソッド定義
  def notification_form(notification)
    @visitor = notification.visitor # 通知を送ってきたユーザー取得
    @visitor_comment = notification.article_comment_id
    @article_comment = nil
    case notification.action # notification.actionの値で処理を変える
    when 'follow'
      tag.a(notification.visitor.name, href: member_path(@visitor)) + 'さんにフォローされました' # aタグで通知を作成したユーザーshowのリンクを作成
    when 'favorite'
      tag.a(notification.visitor.name,
            href: member_path(@visitor)) + 'さんが' + tag.a('あなたの投稿',
                                                            href: article_path(notification.article_id)) + 'をお気に入りしました'
    when 'comment'
      @article_comment = ArticleComment.find_by(id: @visitor_comment)&.body # 投稿に対するコメントとその内容を取得
      tag.a(@visitor.name, href: member_path(@visitor)) + 'さんが' + tag.a('あなたの投稿', href: article_path(notification.article_id)) + 'にコメントしました' # aタグで通知を作成したユーザーと、コメントを受けた投稿詳細へのリンクを作成
    end
  end

  # 自分宛の未確認の通知を返す
  def unchecked_notifications
    @notifications = current_member.passive_notifications.where(is_checked: false)
  end
end
