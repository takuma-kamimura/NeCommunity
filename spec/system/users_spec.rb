require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe 'ユーザー新規登録時の表示テスト' do
    it "名前がない場合はエラーメッセージが表示されること" do
      visit root_path
      visit new_user_path
      # fill_in 'user[name]', with: nil
      # fill_in 'user[email]', with: user.email
      # fill_in 'user[password]', with: user.password
      # fill_in 'user[password_confirmation]', with: user.password_confirmation
      # visit user_posts_path(user, post)
    end
  end

  # pending "add some scenarios (or delete) #{__FILE__}"
end
