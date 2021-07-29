class RatingsController < ApplicationController
  before_action :authenticate_member!
  before_action :set_article_comment

  def create
    @rating = @article_comment.ratings.new(rating_params)
    @rating.member_id = current_member.id
    if @rating.save
      redirect_to request.referer, notice: '評価が保存されました'
    else
      render 'article_comments/show'
    end
  end

  def update
    @rating = Rating.find_by(member_id: current_member, article_comment_id: @article_comment)
    @rating.update(rating_params)
    redirect_to request.referer, notice: '評価が更新されました'
  end

  private

  def rating_params
    params.require(:rating).permit(:rate)
  end
  
  def set_article_comment
    @article_comment = ArticleComment.find(params[:article_comment_id])
  end
  
end
