require 'rails_helper'

RSpec.describe "Users", type: :system do
  before do
    # visit new_user_path
    # fill_in 'user[email]', with: user.email
    # fill_in 'user[password]', with: user.password
    # click_button 'ログイン'
    # visit user_posts_path(user, post)
  end
  describe 'ユーザー新規登録時の表示テスト' do
    it "名前がない場合はエラーメッセージが表示されること" do
      # fill_in 'user[email]', with: user.email
      # fill_in 'user[password]', with: user.password
      # visit user_posts_path(user, post)
    end
  end

  # pending "add some scenarios (or delete) #{__FILE__}"
end
