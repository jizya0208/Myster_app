class AccountHistoriesController < ApplicationController

  def new
    @account_history = AccountHistory.new
    @account = Account.find_by(member_id: current_member.id)
  end

  def create
    # 複数のモデルを一度に更新する処理をおこなうため、原子性を担保するためにトランザクションを使用
    ActiveRecord::Base.transaction do
      # ポイント取引に関連する変数の宣言
      active_member = current_member                             # 送金側ユーザ
      active_account = active_member.account                     # 送金側ユーザの口座
      passive_account = Account.find(params[:account_id])        # 受取側ユーザの口座
      passive_member = Member.find(passive_account.member_id)    # 受取側ユーザ
      amount = params[:account_history][:amount].to_i            # 取引ポイント

      # 取引番号
      transaction_number = TransactionNumber.new
      transaction_number.save!                                   # saveでは、保存に失敗した時にfalseを返す(=例外を発生させない)ので、save!メソッドを使用

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
      redirect_to root_path, notice: '正常にチップ送金が終了しました' # 上記完全成功なら、root_path(ホーム画面へ)
  rescue ActiveRecord::RecordInvalid => e # 以下は例外が発生（プロセスの内どこかが失敗）したときに行う
    flash.now[:alert] = e.message
    render :errors
  rescue ActiveRecord::RecordNotSaved => e
    flash.now[:alert] = e.message
    render :errors
  end

  def index
    @account_histories = AccountHistory.where(account_id: current_member.account.id)
  end

  def charge
    ActiveRecord::Base.transaction do
      # ポイントチャージに関連する変数の宣言
      account = Account.find_by(member_id: current_member)
      case params[:charge_option]
        when "0" then amount = 100
        when "1" then amount = 500
        when "2" then amount = 1000
        when "3" then amount = params[:amount].to_i # シンボルから数値型へ変更
      end
      # 取引番号
      transaction_number = TransactionNumber.new
      transaction_number.save!

      # チャージ履歴
      account_history = transaction_number.account_histories.new(
        transaction_type_id: 2,
        account_id: account.id,
        amount: amount,
        balance: account.balance + amount,
        remark: 'ポイントチャージ'
      )
      account_history.save!

      # 口座のポイント残高を更新
      account.update!(balance: account_history.balance)
    end
    redirect_to root_path, notice: '正常にポイントチャージが終了しました'
  rescue ActiveRecord::RecordInvalid => e   # 以下は例外が発生（プロセスの内どこかが失敗）したときに行う
    render 'root_path', plain: e.message
  rescue ActiveRecord::RecordNotSaved => e
    render 'root_path', plain: e.message
  end

  private

  def account_history_params
    params.require(:account_history).permit(:amount)
  end
  
end
