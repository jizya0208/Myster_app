class FavoritesController < ApplicationController
  before_action :authenticate_member!

  def create
    @article = Article.find(params[:article_id])
    favorite = @article.favorites.new(member_id: current_member.id)
    favorite.save
  end

  def destroy
    @article = Article.find(params[:article_id])
    favorite = @article.favorites.find_by(member_id: current_member.id)
    favorite.destroy
  end
end
