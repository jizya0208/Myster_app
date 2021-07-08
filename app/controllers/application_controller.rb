class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  protected
  # 新規登録、ログイン時にそれぞれ許可するキーを設定
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :integer, :age] )
    devise_parameter_sanitizer.permit(:sign_in, keys: [:name] )                         
  end
end

