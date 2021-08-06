class SearchController < ApplicationController
  def search
    # @keyword = params[:keyword]
    # @articles = Article.search(@keyword)

    respond_to do |format| # サーバーがjson形式で値をかえし、jbuilderファイルを使えるようにする
      format.html
      format.json # jsonで送られた時はその情報はjbuilderへと流れるj(builderの役割としては、html形式だった情報をjsonに変換して、非同期でhtml上で表示をさせることができる形に変換すること)
    end
  end
end
