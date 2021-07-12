class MembersController < ApplicationController
  before_action :authenticate_member!
  before_action :ensure_correct_member, only: [:edit, :update]

  def show
    @member = Member.find(params[:id])
    @relationship = current_member.relationships.new   #フォロー関係を新規に生成するため
  end

  def edit
  end

  def update
    if @member.update(member_params)
      redirect_to member_path(@member), notice: "更新されました"
    else
      render "edit"
    end
  end
  
  def unsubscribe  #退会手続きページを表示する
  end

  def withdraw
    current_member.update(is_deleted: true)
    reset_session
    redirect_to root_path, notice: "ありがとうございました。またのご利用を心よりお待ちしております。"
  end
  
  protected
  def member_params
    params.require(:member).permit(:image, :introduction, :integer, :age)
  end

  def ensure_correct_member
    @member = Member.find(params[:id])
    unless @member == current_member
      redirect_to member_path(current_member)
    end
  end

end
