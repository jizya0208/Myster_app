module SearchHelper

  def emphasize_keyword(body, keyword)
    body_array = body.split(/\R/)
    first_match_line = body_array.find { |e| /#{keyword}/ =~ e }
    truncate_line = if first_match_line.present? #短縮
                      truncate(first_match_line, length: 30)
                    else
                      truncate(body, length: 30)
                    end
    highlight(truncate_line, keyword, :highlighter => '<strong>\1</strong>')
  end

end