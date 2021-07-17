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
    
    #-------------------------------グラフ表示用の変数　(世代別) => 成功 ------------------------------------------
    favorite_members = Member.where(id: @article.favorites.map(&:member_id)) #投稿に紐づくお気に入りから、その会員情報を取得
    ages = favorite_members.map(&:age).map{|age| classify(age)}             #年齢を世代別(10代,20代etc..)に変換した上で再度新しい配列を生成
    @attribute_ratio = ages.group_by(&:itself).map{ |key,value| [key, value.count] }.to_h #世代別とその数をハッシュ化 { 10代 => 3, 20代 => 1, 30代 => 2 }
    @attribute_ratio.each do |k,v|
      ratio = (v * 100).to_f / favorite_members.count
      @attribute_ratio[k] = ratio.round(1)
    end
    #-------------------------------グラフ表示用の変数　(世代・男女別) => 失敗 ------------------------------------------
    favorite_member_attributes = Member.where(id: @article.favorites.map(&:member_id)).pluck(:gender, :age)  # 年齢、性別の二次元配列になるはず　[[22, '男性'] [34, '女性']]
    for i in 0..(favorite_member_attributes.length - 1)     #方針：年齢を世代･男女別(30代･男性etc..)に変換した上で新しい配列を生成　{ '20代･男性' => 2 }
      favorite_member_attributes[i][0] = classify(favorite_member_attributes[i][0].joins(&:itself[i][1]))
    end
    @attribute_ratio = favorite_member_attributes
    @attribute_ratio.each do |k,v|
      ratio = (v * 100).to_f / favorite_member_attributes.count
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

  def classify(age)
    case age
    when age = 10..19
      '10代'
    when age = 20..29
      '20代'
    when age = 30..39
      '30代'
    when age = 40..49
      '40代'
    when age = 50..59
      '50代'
    when age = 60..100
      '60歳以上'
    else
      'その他･非公開'
    end
  end
end
