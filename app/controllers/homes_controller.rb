class HomesController < ApplicationController
  def top
    @articles = Article.recent(4)
  end

  def about; end

  def search_in_questions
    @question_articles = Article.questions.filter_by_category(params[:category_id]).page(params[:page])
  end
end
