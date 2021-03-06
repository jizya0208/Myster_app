class ArticlesController < ApplicationController
  before_action :authenticate_member!
  before_action :ensure_correct_member, only: %i[update destroy]
  before_action :set_sort_options, only: %i[index questions]

  def index
    if @category || @sort_method
      @articles = Kaminari.paginate_array(Article.preload([:member, :article_images]).where(is_closed: nil).search_for(@category, @sort_method)).page(params[:page])
    else
      @articles = Article.shares.page(params[:page])
    end
  end

  def questions
    if @category || @sort_method
      @question_articles = Kaminari.paginate_array(Article.preload([:member, :article_images]).where(is_closed: false).search_for(@category, @sort_method)).page(params[:page])
    else
      @question_articles = Article.questions.page(params[:page])
    end
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.member_id = current_member.id
    if @article.save
      @article.article_images_images.each do |img|
        tags = Vision.get_image_data(img) # API(Cloud Vision API)を読み込んだモジュールで定義したメソッド。
        tags.each do |tag|
          ja_tag = Translate.to_japanese(tag) # タグの日本語化
          ja_tag = Tag.find_or_create_by(name: ja_tag)
          @article.tags << ja_tag
        end
      end
      redirect_to questions_path, notice: '投稿が完了しました' if @article.is_closed == false #ステータス相談中の場合、回答募集中一覧へ
      redirect_to articles_path, notice: '投稿が完了しました' if @article.is_closed.nil?
    else
      render 'new'
    end
  end

  def show
    @article = Article.find(params[:id])
    @article_comment = ArticleComment.new

    @parent_comments = ArticleComment.eager_load([:member, :replies]).where(article_id: params[:id], parent_id: nil) # 投稿に結びつく親コメント(コメントへの返信除く)
    @rating = Rating.new

    #-------------------グラフ表示用の変数 (世代・男女別) --------------------------
    favorite_member_attributes = Member.where(id: @article.favorites.map(&:member_id)) # 投稿に紐づくお気に入りから、その会員情報を取得する
    array = favorite_member_attributes.map(&:classify)                                 # 世代･男女別(30代前半女性etc..)に変換した上で、新たな配列を生成
    @attribute_ratio = p array.group_by(&:itself).map{ |key,value| [key, value.size] }.sort{ |a, b| b[1] <=> a[1] }.to_h # 上記を評価し同じ区分の数をvalueに入れ、当該valueで降順にソートし、ハッシュ化
    @attribute_ratio.each do |k, v|
      ratio = (v * 100).to_f / favorite_member_attributes.size   # 区分ごとのデータ数割合を%表示
      @attribute_ratio[k] = ratio.round(1)
    end
  end

  def update
    @article.is_closed = true
    @article.save ? (redirect_to article_path(@article), notice: 'ステータスが更新されました') : (render 'show')
  end

  def destroy
    @article.destroy
    redirect_to articles_path, notice: '削除されました'
  end

  def tag
    @tag = Tag.find_by(name: params[:name])
    @articles = @tag.articles.page(params[:page]).reverse_order
  end

  def search
    @keyword = params[:keyword]
    return nil if @keyword.blank?
    @articles = Article.search(@keyword).limit(6)
    respond_to do |format| # サーバーがjson形式で値をかえし、jbuilderファイルを使えるようにする。respond_toがフォーマット毎に処理を分ける役割
      format.html
      format.json # jsonで送られた時はその情報はjbuilderへと流れるjbuilderの役割としては、html形式だった情報をjsonに変換して、非同期でhtml上で表示をさせることができる形に変換させること)
    end
  end
  
  private

  def article_params
    params.require(:article).permit(:title, :body, :category_id, :is_closed, article_images_images: [])
  end

  def ensure_correct_member
    @article = Article.find(params[:id]) # 取得したデータ(@article)をbefore_actionでセットするからインスタンス変数にしている
    redirect_to articles_path unless @article.member == current_member
  end
  
  def set_sort_options
    @category = params[:category_id]
		@sort_method = params[:sort_method]
    @sort_options = [
      {id: "created_at_DESC", name: "投稿が新しい順" },
      {id: "created_at_ASC", name: "投稿が古い順"},
      {id: "comment_ASC", name: "コメントが少ない順"},
      {id: "favorite_DESC", name: "お気に入りが多い順"}
    ]
  end
end
