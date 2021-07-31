class ArticleCommentsController < ApplicationController
  before_action :authenticate_member!
  before_action :set_article

  def create
    @article_comment = @article.article_comments.new(article_comment_params)
    @article_comment.member_id = current_member.id
    if @article_comment.save
      @article.create_notification_comment!(current_member, @article_comment.id)
      respond_to :js
    else
      render 'error'  # 非同期通信のため、バリデーションに引っかかった場合のjsファイルを用意する。
    end
  end

  def destroy
    article_comment = @article.article_comments.find_by(id: params[:id])
    article_comment.destroy
  end

  def show
    @article_comment = ArticleComment.find(params[:id])
    @rating = Rating.new
  end

  private

  def article_comment_params
    params.require(:article_comment).permit(:body, :image)
  end
  
  def set_article
    @article = Article.find(params[:article_id])
  end
end
