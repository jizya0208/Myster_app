class HomesController < ApplicationController
  def top
    @article = Article.where(is_closed: nil).limit(3)
  end

  def about
  end
end
