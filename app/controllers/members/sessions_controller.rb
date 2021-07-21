class Members::SessionsController < Devise::SessionsController
  before_action :reject_member, only: [:create]

  def guest_login # ゲストユーザーとしてログイン
    member = Member.guest
    member.build_account(balance: 0).save if member.account == nil 
    sign_in member # Deviseのsign_inメソッド。
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  end

  private

  def reject_member
    @member = Member.find_by(name: params[:member][:name]) # ログイン時に入力されたユーザ名から情報をセット
    if @member && (@member.valid_password?(params[:member][:password]) && @member.active_for_authentication? == false) # 入力されたパスワードが正しいこと 且つ　会員ステータスが退会済み
      sign_out
      redirect_to new_member_session_path, alert: 'このアカウントは退会済みです。'
    end
  end
end
