module ArticlesHelper
  # 文字列.gsub(/正規表現/, 正規表現に該当した箇所を置換した後の文字列)
  # html_safeは、対象の文字列が安全であるとマーキングするメソッド。
  def render_with_tags(body)
    body.gsub(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/){|word| link_to word, "/article/tag/#{word.delete("#")}"}.html_safe
  end 
end
