require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
  # let(:user) { create(:user) }
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
  end
end
