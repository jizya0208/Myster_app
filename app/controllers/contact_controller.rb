class ContactController < ApplicationController
  def index # 入力画面を表示
    @contact = contact.new
    render :index
  end

  def confirm # 入力値のチェック
    @contact = Contact.new(contact_params)
    if @contact.valid?
      # OK。確認画面を表示
      render :confirm
    else
      # NG。入力画面を再表示
      render :index
    end
  end

  def thanks
    # メール送信
    @contact = Contact.new(contact_params)
  end

  private
  def contact_params
    params(:contact).permit(:name, :email, :message)
  end
end
