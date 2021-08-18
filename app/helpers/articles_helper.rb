module ArticlesHelper
  # 文字列.gsub(/正規表現/, 正規表現に該当した箇所を置換した後の文字列)
  # html_safeは、対象の文字列が安全であるとマーキングするメソッド。
  def render_with_tags(body)
    body.gsub(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/) { |word| link_to word, "/article/tag/#{word.delete('#')}" }.html_safe
  end

  # text:カットしたい対象の文字列,len:字数
  def cut_off(text, len)
    if !text.nil?
      if text.length < len # 字数制限以下ならそのまま返す
        text
      else
        text.scan(/^.{#{len}}/m)[0] + '…' # ^ => 直後の文字が行頭にある場合にマッチ . => 任意の一文字　{n} => 直前の文字の桁数(len)を指定  m(オプション) => 改行にもマッチ
      end
    else
      ''
    end
  end
  
  # 検索文字との一致部分を強調して表示させる
  def emphasize_keyword(body, keyword)
    body_array = body.split(/\R/)
    first_match_line = body_array.find { |e| /#{keyword}/ =~ e }
    truncate_line = if first_match_line.present? # 短縮
                      truncate(first_match_line, length: 30)
                    else
                      truncate(body, length: 30)
                    end
    highlight(truncate_line, keyword, highlighter: '<strong>\1</strong>')
  end
  
   # 投稿者とログインユーザが同一であれば、削除ボタンを表示する
  def delete_button(article)
    if current_member_has?(article)
      link_to '', article_path(article), method: :delete, data: { confirm: 'この投稿を削除しますか？', cancel: 'キャンセル',commit: 'OK'}, title: '投稿削除', class: "destroy_article_#{article.id} fas fa-trash-alt", id: "delete-btn"
    end
  end
  
  # 投稿者とログインユーザが同一 且つ 相談ステータスが相談中であれば、ステータス更新ボタンを表示
  def resolve_button(article)
    if Article.find_by(id: article.id, member_id: current_member, is_closed: false)
      link_to '', article_path(article), method: :patch, data: { confirm: 'ステータス解決済みにすると回答募集ページへの掲示を終了します。本当によろしいですか？', cancel: 'キャンセル',commit: 'OK' }, title: '相談ステータス更新', class: "fas fa-check-circle"
    end
  end
  
  # 投稿記事を引数に渡し、ステータスに応じて文字列を返す
  def article_status(article)
    case article.is_closed
      when true then '解決済み' 
      when false then '相談中' 
      when nil then 'シェア'    
    end 
  end
end
