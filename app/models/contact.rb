class Contact
  include ActiveModel::Model #「ActiveModel」は、ActiveRecordの中でデータベースに関連する部分以外の機能を切り出したモジュール。

  attr_accessor :name, :email, :message # インスタンス変数name, email, messageの読み取りメソッドと書き込みメソッドの両方を定義

  validates :name, presence: true
  validates :email, presence: true
end