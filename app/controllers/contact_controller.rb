class ContactController < ApplicationController
  before_action :authenticate_member!
  
  def index # 入力画面を表示
    @contact = Contact.new
  end

  def confirm # 入力値のチェック
    @contact = Contact.new(contact_params)
    @contact.valid? ? (render :confirm ) : (render :index) # 入力値が有効かどうかで条件分岐。 OKなら確認画面を表示。 NGなら入力画面を再表示
  end

  def thanks # メール送信
    @contact = Contact.new(contact_params)
    ContactMailer.received_email(@contact, current_member).deliver # received_email(自動返信メール) => contact_mailerにて定義済み。 deliver =>  メール送信を担うMailerクラス特異のメソッド。
    render :thanks # 完了画面を表示
  end

  private
  def contact_params
    params.require(:contact).permit(:name, :message)
  end
end
