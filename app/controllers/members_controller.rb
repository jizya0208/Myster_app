class MembersController < ApplicationController
  before_action :authenticate_member!
  before_action :ensure_correct_member, only: %i[edit update]

  def show
    @member = Member.find(params[:id])
    @relationship = current_member.relationships.new   # フォロー関係を新規に生成するため
    @account_histroy = AccountHistory.new # ポイント送金履歴を新規に生成するため
    @account = Account.find_by(member_id: @member.id)
  end

  def edit; end

  def update
    if @member.update(member_params)
      redirect_to member_path(@member), notice: '更新されました'
    else
      render 'edit'
    end
  end

  # 退会手続きページを表示する
  def unsubscribe; end

  def withdraw
    current_member.update(is_deleted: true)
    reset_session
    redirect_to root_path, notice: 'ありがとうございました。またのご利用を心よりお待ちしております。'
  end

  protected

  def member_params
    params.require(:member).permit(:image, :introduction, :integer, :age, :gender)
  end

  def ensure_correct_member
    @member = Member.find(params[:id])
    redirect_to member_path(current_member) unless @member == current_member
  end
end
