class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?


  def after_sign_in_path_for(resource)  #ログイン後の遷移ページをマイページを指定
    member_path(resource)
  end

  def after_sign_out_path_for(resource)  #ログアウト後の遷移ページをルートパスを指定
    root_path
  end

  def configure_permitted_parameters     #新規登録、ログイン時にそれぞれ許可するキーを設定
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email] )
    devise_parameter_sanitizer.permit(:sign_in, keys: [:name] )
  end

end

