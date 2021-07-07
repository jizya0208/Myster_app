class ArticleCommentsController < ApplicationController
  before_action :authenticate_member!

  def create
    @article = Article.find(params[:article_id])
    @article_comment = @article.article_comments.new(article_comment_params)
    @article_comment.member_id = current_member.id
    unless @article_comment.save
      render 'error'
    end
  end

  def destroy
    @article = Article.find(params[:article_id])
    # 結びつく投稿とコメントIDから抽出
    article_comment = @article.article_comments.find_by(params[:id])
    article_comment.destroy
  end
  

  private

  def article_comment_params
    params.require(:article_comment).permit(:body, :image)
  end
end
