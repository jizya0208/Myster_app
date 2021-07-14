class AccountHistoriesController < ApplicationController
  def new
    @account_history = AccountHistory.new
    @account = Account.find_by(member_id: current_member.id)
  end

  def create
    ActiveRecord::Base.transaction do
      # ポイント取引に関連する変数の宣言
      active_member = current_member
      active_account = Account.find_by(member_id: active_member)
      passive_account =Account.find(params[:account_id])
      passive_member = Member.find(passive_account.member_id)
      amount = params[:account_history][:amount].to_i

      #取引番号
      transaction_number = TransactionNumber.new
      transaction_number.save!

      # ポイント送金側の履歴
      active_account_history = transaction_number.account_histories.build(
        transaction_type_id: 1,
        account_id: active_account.id,
        amount: amount,
        balance: active_account.balance - amount,
        remark: "#{passive_member.name}さんへのチップ支払"
      )
      active_account_history.save!

      # ポイント受取側の履歴
      passive_account_history = transaction_number.account_histories.build(
        transaction_type_id: 2,
        account_id: passive_account.id,
        amount: amount,
        balance: passive_account.balance + amount,
        remark: "#{active_member.name}さんからのチップ受取"
      )
      passive_account_history.save!

      # 口座のポイント残高を更新
      active_account.update!(balance:  active_account_history.balance)
      passive_account.update!(balance: passive_account_history.balance)
    end
      redirect_to root_path, notice: "正常にチップ送金が終了しました" #上記完全成功なら、root_path(ホーム画面へ)
  rescue ActiveRecord::RecordInvalid => e                                                       #以下は例外が発生（プロセスの内どこかが失敗）したときに行う
    render "root_path", plain: e.message
  end

  def index
    @account_histories = AccountHistory.where(account_id: current_member.account.id)
  end

  def charge
    ActiveRecord::Base.transaction do
      # ポイントチャージに関連する変数の宣言
      account = Account.find_by(member_id: current_member)
      amount = params[:amount].to_i
      # 取引番号
      transaction_number = TransactionNumber.new
      transaction_number.save!

      # チャージ履歴
      account_history = transaction_number.account_histories.new(
        transaction_type_id: 2,
        account_id: account.id,
        amount: amount,
        balance: account.balance + amount,
        remark: "ポイントチャージ"
      )
      account_history.save!
      # 口座のポイント残高を更新
      account.update!(balance: account_history.balance)
    end
      redirect_to root_path, notice: "正常にポイントチャージが終了しました"
  rescue ActiveRecord::RecordInvalid => e                                                       #以下は例外が発生（プロセスの内どこかが失敗）したときに行う
    render "root_path", plain: e.message
  rescue ActiveRecord::RecordNotSaved => e   
    render "root_path", plain: e.message
  end

  private
  def account_history_params
    params.require(:account_history).permit(:amount)
  end
end
