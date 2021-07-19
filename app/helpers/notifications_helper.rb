module NotificationsHelper
  def notification_form(notification) #アクションに応じて通知メッセージを返すヘルパーメソッドを定義
    @visitor = notification.visitor   #通知を送ってきたユーザーを取得
    @visitor_comment = notification.article_comment_id
    case notification.action  # notification.actionがfollowかlikeかcommentかで処理を変える
    when 'follow'
      tag.a(notification.visitor.name, href: member_path(@visitor)) + 'さんにフォローされました'  #aタグで通知を作成したユーザーshowのリンクを作成
    when 'favorite'
      tag.a(notification.visitor.name, href: member_path(@visitor)) + 'さんが' + tag.a('あなたの投稿', href: article_path(notification.article_id)) + 'をお気に入りしました'
    when 'comment'
      @article_comment = ArticleComment.find_by(id: @visitor_comment)
      @article_comment_body =@article_comment.body    #コメントの内容を取得
      @article_title =@article_comment.article.title  #投稿のタイトルを取得
      tag.a(@visitor.name, href: member_path(@visitor)) + 'さんが' + tag.a("#{@article_title}", href: article_path(notification.article_id)) + 'にコメントしました'
    end
  end
end
