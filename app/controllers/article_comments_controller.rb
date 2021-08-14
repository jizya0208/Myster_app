class ArticleCommentsController < ApplicationController
  before_action :authenticate_member!
  before_action :set_article

  def create
    #投稿に紐づいたコメントの作成
    @article_comment = @article.article_comments.new(article_comment_params)
    @article_comment.member_id = current_member.id

    @parent_comments = ArticleComment.where(article_id: @article.id, parent_id: nil)
    @article_comment_reply = @article.article_comments.new

    if @article_comment.save
      @article.create_notification_comment!(current_member, @article_comment.id)
      respond_to :js
    else
      render 'error'  # 非同期通信のため、バリデーションに引っかかった場合のjsファイルを用意する。
    end
  end

  def destroy
    @parent_comments = ArticleComment.where(article_id: @article.id, parent_id: nil)
    @article_comment_reply = @article.article_comments.new
    article_comment = @article.article_comments.find_by(id: params[:id])
    article_comment.destroy
    respond_to :js
  end

  def show
    @article_comment = ArticleComment.find(params[:id])
    @article_comment_reply = @article.article_comments.new
    @rating = Rating.new
  end

  private

  def article_comment_params
    params.require(:article_comment).permit(:body, :image, :parent_id)
  end

  def set_article
    @article = Article.find(params[:article_id])
  end
end
