module ArticleCommentsHelper
  def answer_from_other_member(article, comment)
    !(article.is_closed.nil?) && (current_member != comment.member)
  end
end
