class SearchController < ApplicationController
  
  def search
    @keyword = params[:keyword]
    @articles = Article.search(@keyword)
  end
end