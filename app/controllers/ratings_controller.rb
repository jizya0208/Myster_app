class RatingsController < ApplicationController
  before_action :authenticate_member!

  def create
    @article_comment = ArticleComment.find(params[:article_comment_id])
    @rating = @article_comment.ratings.new(rating_params)
    @rating.member_id = current_member.id
    if @rating.save
      redirect_to request.referer, notice: '評価が保存されました'
    else
      render 'article_comments/show'
    end
  end

  def update
    @article_comment = ArticleComment.find(params[:article_comment_id])
    @rating = Rating.find_by(member_id: current_member, article_comment_id: @article_comment)
    @rating.update(rating_params)
    redirect_to request.referer, notice: '評価が更新されました'
  end

  private

  def rating_params
    params.require(:rating).permit(:rate)
  end
end
