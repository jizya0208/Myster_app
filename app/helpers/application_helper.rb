module ApplicationHelper
  def current_member_has?(instance)
    member_signed_in? && current_member == instance.member # 会員がログイン且つインスタンスに紐付いた会員が同一か
  end
  
  def other_member?(member)
    member != current_member # 会員がログイン且つインスタンスに紐付いた会員が同一か
  end
end