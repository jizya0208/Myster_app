require 'rails_helper'
RSpec.describe Member, type: :model do
  describe 'モデルのテスト' do
    it "有効なmemberの場合は保存されるか" do
      expect(build(:member)).to be_valid                              # FactoryBotで作ったデータが有効であるかを確認
    end

    context "空白のバリデーションチェック" do                         # contextは「〜な時」場合わけのイメージ
      it "nameが空白の場合にエラーメッセージが返ってくるか" do
        member = build(:member, name: nil)                            # memberにnameカラムを空で保存したものを代入
        member.valid?                                                 # バリデーションチェック(有効か)をおこなう
        expect(member.errors[:name]).to include("を入力してください") # nameカラムでエラーが出て、エラーメッセージに"を入力してください"が含まれているか？
      end
      it "emailが空白の場合にエラーメッセージが返ってくるか" do
        member = build(:member, email: nil)
        member.valid?
        expect(member.errors[:email]).to include("を入力してください")
      end
      it "passwordが空白の場合にエラーメッセージが返ってくるか" do
        member = build(:member, password: nil)
        member.valid?
        expect(member.errors[:password]).to include("を入力してください")
      end
    end


    describe "password length" do         #パスワードの長さテスト
      context "パスワードが６桁の時" do   #パスワードが6桁の時と５桁の時のテストを行うことで、どの位置からバリデーションが用意されているのか可視化している
        it "正しい" do
          member = FactoryBot.build(:member, password: "a" * 6, password_confirmation: "a" * 6)
          expect(member).to be_valid
        end
      end

      context "パスワードが５桁の時" do
        it "正しくない" do
          member = FactoryBot.build(:member, password: "a" * 5, password_confirmation: "a" * 5)
          expect(member).to be_invalid
        end
      end
    end

    it "nameの文字数が21文字以上の場合エラーメッセージが返ってくるか" do
      member = build(:member, name: "hogehogehogehogehogehoge")                   # nameカラムに21文字以上の文字列を入れる わかりやすくベタ書き
      member.valid?
      expect(member.errors[:name]).to include("は20文字以内で入力してください")
    end

    context "一意性制約の確認" do
      before do
        @member = build(:member)                            # itの前に@memberにbuild(:member)を代入, 以下でブロックを超えて使うのでインスタンス変数
      end

      it "同じnameの場合エラーメッセージが返ってくるか" do
        @member.save!
        another_member = build(:member)                     # another_memberにbuild(:member)を保存
        another_member.name = @member.name                  # another_memberのnameカラムに@memberと同じnameを代入
        another_member.valid?                               # @memberと同じnameになるので、バリデーションチェックに引っかかる挙動を期待
        expect(another_member.errors[:name]).to include("はすでに存在します")
      end
      it "同じemailの場合エラーメッセージが返ってくるか" do
        @member.save!
        another_member = build(:member)
        another_member.email = @member.email
        another_member.valid?
        expect(another_member.errors[:email]).to include("はすでに存在します")
      end
    end
  end
end