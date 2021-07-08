class ArticlesController < ApplicationController
  def confirm
  end

  def index
    @articles = Article.where(is_closed: nil).page(params[:page]).reverse_order
  end
  
  def inquire
   @inquiring_articles = Article.where(is_closed: false).page(params[:page]).reverse_order
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.member_id = current_member.id
    if @article.save
      redirect_to articles_path
    else
      render 'confirm'
    end
  end

  def show
    @article = Article.find(params[:id])
    @article_comment = ArticleComment.new
  end

  def update
    @article = Article.find(params[:id])
    if @article.update(article_params)
      redirect_to article_path(@article), notice: "ステータスが更新されました"
    else
      render "show"
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to articles_path, notice: "削除されました"
  end


  private
  def article_params
    params.require(:article).permit(:title, :body, :category_id, :is_closed, article_images_images: [])
  end
end
