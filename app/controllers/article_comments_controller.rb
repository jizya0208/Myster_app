class ArticleCommentsController < ApplicationController
  before_action :authenticate_member!
  before_action :set_article
  before_action :set_parent_comment, only: %i[reply close]

  def reply
    @replies = ArticleComment.eager_load(:member, :replies).where(parent_id: params[:id]) # 投稿に結びつく親コメント(コメントへの返信除く)
    @article_comment_reply = @article.article_comments.new
    @parent_comment =  ArticleComment.find_by(id: params[:id], article_id: @article)
  end

  def close;end

  def create
    #投稿に紐づくコメントの作成
    @article_comment = @article.article_comments.new(article_comment_params)
    @article_comment.member_id = current_member.id

    @parent_comments = ArticleComment.where(article_id: @article.id, parent_id: nil)
    @article_comment_reply = @article.article_comments.new
    @parent_comment = ArticleComment.find_by(id: @article_comment.parent)

    if @article_comment.save
      @article.create_notification_comment!(current_member, @article_comment.id)
      respond_to :js
    else
      render 'error'  # 非同期通信のため、バリデーションに引っかかった場合のjsファイルを用意する。
    end
  end

  def destroy
    @parent_comments = ArticleComment.where(article_id: @article.id, parent_id: nil)
    @article_comment_reply = @article.article_comments.new
    article_comment = @article.article_comments.find_by(id: params[:id])
    article_comment.destroy
    respond_to :js
  end

  def show # 写真クリックでshowアクションが実行され、js.erbファイルが呼び出されるようにする。
    @article_comment = ArticleComment.find_by(id: params[:id], article_id: @article)
    respond_to do |format| #
      format.html
      # link_toメソッドをremote: trueに設定したのでリクエストはjs形式で行われる
      format.js
    end
  end


  private

  def article_comment_params
    params.require(:article_comment).permit(:body, :image, :parent_id)
  end

  def set_article
    @article = Article.find(params[:article_id])
  end

  def set_parent_comment
    @parent_comment =  ArticleComment.find_by(id: params[:id], article_id: @article)
  end
end
