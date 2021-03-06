require 'base64'
require 'json'
require 'net/https'

module Vision
  class << self
    def get_image_data(image_file)
      # APIのURL作成
      api_url = "https://vision.googleapis.com/v1/images:annotate?key=#{ENV['GOOGLE_API_KEY']}"

      # 画像をbase64にエンコード(符号化)
      base64_image = Base64.encode64(open("#{Rails.root}/public/uploads/#{image_file.id}").read)

      # APIリクエスト用のJSONパラメータ
      params = {
        requests: [{
          image: {
            content: base64_image
          },
          features: [
            {
              type: 'LABEL_DETECTION' #画像全体に対して画像コンテンツ分析を実行し、結果を返す
            }
          ]
        }]
      }.to_json

      # Google Cloud Vision APIにリクエスト
      uri = URI.parse(api_url)                    #パースの役割はデータを解析し必要なデータを取り出すこと
      https = Net::HTTP.new(uri.host, uri.port) # ホスト名とはドメイン名のこと(translation.googleapis.comとか)で、ポート番号とはアプリなどが使用する出入口(443とか)
      https.use_ssl = true # SSL（Secure Sockets Layer）とは、インターネット上におけるウェブブラウザとウェブサーバ間でのデータの通信を暗号化し、送受信させる仕組み
      request = Net::HTTP::Post.new(uri.request_uri)
      request['Content-Type'] = 'application/json'
      response = https.request(request, params)
      response_body = JSON.parse(response.body)
      # APIレスポンス出力
      if (error = response_body['responses'][0]['error']).present?
        raise error['message']
      else
        response_body['responses'][0]['labelAnnotations'].pluck('description').take(3)
      end
    end
  end
end