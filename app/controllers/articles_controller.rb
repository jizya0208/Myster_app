class ArticlesController < ApplicationController
  before_action :authenticate_member!
  before_action :ensure_correct_member, only: [:update, :destroy]

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
      redirect_to member_path(current_member), notice: '投稿が完了しました'
    else
      render 'new'
    end
  end

  def show
    @article = Article.find(params[:id])
    @article_comment = ArticleComment.new
    #-------------------グラフ表示用の変数　(世代・男女別) --------------------------
    favorite_member_attributes = Member.where(id: @article.favorites.map(&:member_id)) #投稿に紐づくお気に入りから、その会員情報を取得する
    array = favorite_member_attributes.map(&:classify)                                 #世代･男女別(30代前半女性etc..)に変換した上で、新たな配列を生成
    @attribute_ratio = array.group_by(&:itself).map{ |key,value| [key, value.count] }.to_h  # 上記の配列を評価して、同じ区分の数をバリューに入れハッシュ化
    @attribute_ratio.each do |k,v|                                                          
      ratio = (v * 100).to_f / favorite_member_attributes.count   # それぞれの割合を%表示
      @attribute_ratio[k] = ratio.round(1)
    end
  end

  def update
    @article.is_closed = true
    if @article.save
      redirect_to article_path(@article), notice: "ステータスが更新されました"
    else
      render "show"
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path, notice: "削除されました"
  end

  def tag
    @tag = Tag.find_by(name: params[:name])
    @articles = @tag.articles.page(params[:page]).reverse_order
  end

  private
  def article_params
    params.require(:article).permit(:title, :body, :category_id, :is_closed, article_images_images: [])
  end

  def ensure_correct_member
    @article = Article.find(params[:id])
    unless @article.member == current_member
      redirect_to articles_path
    end
  end
end
