class Contact
  include ActiveModel::Model #「ActiveModel」は、ActiveRecordの中でデータベースに関連する部分以外の機能を切り出したモジュール。

  attr_accessor :name, :message # インスタンス変数name, messageの読み取りメソッドと書き込みメソッドの両方を定義

  validates :name, presence: {:message => 'お名前を入力してください'}
  validates :message, presence: {:message => 'お問合せ内容を入力してください'}
end