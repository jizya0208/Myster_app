class ContactMailer < ApplicationMailer
  default from: "pf.myster@gmail.com" # 送信元アドレス

  def received_email(contact, member) # 問合せに対する返信を生成するメソッド
    @contact = contact
    mail to: member.email, bcc: ENV["SEND_MAIL"], subject: "お問い合わせについて【自動送信】" # メール送信先/ BCC / メール題名
  end
end
