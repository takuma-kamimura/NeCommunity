require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'User-Create' do
    it "名前がない場合は登録できないこと" do
      user = build(:user, name: nil)
      user.valid? # バリデーションにより保存できないかチェック
      expect(user.errors[:name]).to include("を入力してください")
    end
    it "メールアドレスがない場合は登録できないこと" do
      user = build(:user, email: nil)
      user.valid? # バリデーションにより保存できないかチェック
      expect(user.errors[:email]).to include("を入力してください")
    end
    it "パスワードがない場合は登録できないこと" do
      user = build(:user, password: nil)
      user.valid? # バリデーションにより保存できないかチェック
      expect(user.errors[:password]).to include("を入力してください")
    end
    it "パスワードが確認がない場合は登録できないこと" do
      user = build(:user, password_confirmation: nil)
      user.valid? # バリデーションにより保存できないかチェック
      expect(user.errors[:password_confirmation]).to include("を入力してください")
    end
    it "名前・メールアドレス・パスワードが３文字以上で入力され新規登録が有効" do
      user = build(:user)
      expect(user).to be_valid
    end
  end
end
