class Inquiry
  include ActiveModel::Model

  attr_accessor :name, :email, :message # アクセサメソッドを定義することで、インスタンス変数に外部からアクセスできるようになる

  validates :name, :presence => {:message => '名前を入力してください'}
  validates :email, :presence => {:message => 'メールアドレスを入力してください'}
end