require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'User-Create' do
    it "名前がない場合は登録できないこと" do
      user = build(:user, name: nil)
      user.valid? # バリデーションにより保存できないかチェック
      expect(user.errors[:name]).to include("を入力してください")
    end
    it "名前が16文字以上の場合は登録できないこと" do
      user = build(:user, name: 'a' * 16)
      user.valid? # バリデーションにより保存できないかチェック
      expect(user.errors[:name]).to include("は15文字以内で入力してください")
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
    it "パスワード確認がない場合は登録できないこと" do
      user = build(:user, password_confirmation: nil)
      user.valid? # バリデーションにより保存できないかチェック
      expect(user.errors[:password_confirmation]).to include("を入力してください")
    end
    it "パスワードが2文字以下の場合は登録できないこと" do
      user = build(:user, password_confirmation: 'te', password: 'te')
      user.valid? # バリデーションにより保存できないかチェック
      expect(user.errors[:password]).to include("は3文字以上で入力してください")
    end
    it "名前・メールアドレス・パスワードが３文字以上で入力され新規登録が有効" do
      user = build(:user)
      expect(user).to be_valid
    end
  end
  describe 'User-profile' do
    it "自己紹介が201文字以上の場合は登録できないこと" do
      user = build(:user, self_introduction: 'a' * 201)
      user.valid? # バリデーションにより保存できないかチェック
      expect(user.errors[:self_introduction]).to include("は200文字以内で入力してください")
    end
    it "自己紹介が200文字以内の場合は登録が有効" do
      user = build(:user, self_introduction: 'a' * 200)
      expect(user).to be_valid
    end
  end
end
