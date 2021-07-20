class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # ログイン後の遷移ページをマイページを指定
  def after_sign_in_path_for(resource)
    member_path(resource)
  end

  # ログアウト後の遷移ページをルートパスを指定
  def after_sign_out_path_for(_resource)
    root_path
  end

  # 新規登録、ログイン時にそれぞれ許可するキーを設定
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name email])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:name])
  end
end
