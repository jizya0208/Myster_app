class HomesController < ApplicationController
  def top
    @articles = Article.where(is_closed: nil).limit(4).order(created_at: 'DESC')
  end

  def about; end

  def search_in_shares
    @articles = Article.where(is_closed: nil).filter_by_category(params[:category_id]).page(params[:page]).reverse_order
  end

  def search_in_inquiries
    @articles = Article.where(is_closed: false).filter_by_category(params[:category_id]).page(params[:page]).reverse_order
  end
end
