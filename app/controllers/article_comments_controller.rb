class ArticleCommentsController < ApplicationController
  before_action :authenticate_member!

  def create
    @article = Article.find(params[:article_id])
    @article_comment = @article.article_comments.new(article_comment_params)
    @article_comment.member_id = current_member.id
    unless @article_comment.save
      render 'error'  #非同期通信のため、バリデーションに引っかかった場合のjsファイルを用意する。
    end
  end

  def destroy
    @article = Article.find(params[:article_id])
    # 結びつく投稿とコメントIDから抽出
    article_comment = @article.article_comments.find_by(params[:id])
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
end
