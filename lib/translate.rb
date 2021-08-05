require 'net/http'
require 'uri'
require 'json'

module Translate
  class << self
    def to_japanese(text)
      # URLとはインターネット上に存在するファイルの場所を示すもので、Web上の住所にあたる。URIはインターネット上に存在するあらゆるファイルを識別する総称(広義)
      url = URI.parse('https://translation.googleapis.com/language/translate/v2')
      params = {
        q: text,                                  # 翻訳前の単語(配列)
        target: "ja",                             # 翻訳したい言語
        source: "en",                             # 翻訳する言語の種類
        key: "#{ENV['GOOGLE_API_KEY']}"
      }
      https = Net::HTTP.new(url.host, url.port)   # 汎用データ転送プロトコル HTTP を扱うNetというモジュール。
      https.use_ssl = true                        # HTTPS形式にする(最近の外部APIはこうしないと使えないケースが多い)
      request = Net::HTTP::Post.new(url.request_uri)
      request['Content-Type'] = 'application/json'# ファイルの種類を表す情報 => JSON形式(各プログラミング言語間のデータの受渡しを容易にする)  
      url.query = URI.encode_www_form(params)
      res = Net::HTTP.get_response(url)           # get_responseで外部APIのurlに対し、HTTPメソッドのリクエストを送りレスポンスを受け取る
      # レスポンスのjsonの言語の翻訳結果の部分のパラメータをパースする
      JSON.parse(res.body)["data"]["translations"].first["translatedText"] # data => 各クエリ (q) に対する言語翻訳応答の一覧。
    end
  end
end