
[1mFrom:[0m /home/ec2-user/environment/Myster/app/controllers/account_histories_controller.rb:13 AccountHistoriesController#create:

     [1;34m8[0m:       [1;34;4mActiveRecord[0m::[1;34;4mBase[0m.transaction [32mdo[0m
     [1;34m9[0m:         transaction_number = [1;34;4mTransactionNumber[0m.create!
    [1;34m10[0m:         active_member = current_member
    [1;34m11[0m:         active_account = [1;34;4mAccount[0m.find_by([35mmember_id[0m: active_member)
    [1;34m12[0m:         binding.pry
 => [1;34m13[0m:         passive_member = [1;34;4mMember[0m.find(params[[33m:account_id[0m].to_i)
    [1;34m14[0m:         passive_account =[1;34;4mAccount[0m.find_by([35mmember_id[0m: passive_member)
    [1;34m15[0m: 
    [1;34m16[0m:         [1;34m# ポイント送金側の履歴[0m
    [1;34m17[0m:         active_account_history = [1;34;4mAccountHistory[0m.new(
    [1;34m18[0m:           [35mtransaction_number_id[0m: transaction_number.id,

