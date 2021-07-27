require 'rails_helper'

RSpec.describe Article, type: :model do
  describe 'モデルのテスト' do
    it "有効なarticleの場合は保存されるか" do
      expect(build(:article)).to be_valid
    end

    context "空白のバリデーションチェック" do
      it "titleが空白の場合にエラーメッセージが返ってくるか" do
        article = build(:article, title: nil)
        article.valid?
        expect(article.errors[:title]).to include("を入力してください")
      end
      it "bodyが空白の場合にエラーメッセージが返ってくるか" do
        article = build(:article, body: nil)
        article.valid?
        expect(article.errors[:body]).to include("を入力してください")
      end
      it "category_idが空白の場合にエラーメッセージが返ってくるか" do
        article = build(:article, category: nil)
        article.valid?
        expect(article.errors[:category]).to include("を入力してください")
      end
    end

    it "bodyの文字数が201文字以上の場合エラーメッセージが返ってくるか" do
      article = create(:article)
      article.body = Faker::Lorem.characters(number: 201)  # Faker::Lorem.characters(number: 201)でランダムな文字列を201字で作成できる
      article.valid?
      expect(article.errors[:body]).to include("は200文字以内で入力してください")
    end
  end
end