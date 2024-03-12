require 'rails_helper'

RSpec.describe "Admin::Users::Users", type: :system do
  let(:general1) { create(:user, :general)}
  let(:general2) { create(:user, :general)}
  let(:general3) { create(:user, :general)}
  let(:admin) { create(:user, :admin)}
  before do
    # login_process_admin(admin)
  end
  describe '管理画面のログインテスト' do
    context '入力に不備がある場合にログインに失敗し、エラーメッセージが表示されること' do
      it '一般ユーザーの場合はエラーメッセージが表示されること' do
        visit admin_login_path
        fill_in 'email', with: general1.email
        fill_in 'password', with: 'password'
        click_button 'Login'
        expect(page).to have_content('権限がありません')
        expect(page).to have_content('管理者ログインページ')
        expect(current_path).to eq(admin_login_path)
      end
    end
    context '入力内容が正常' do
      it '正常にログインができ、管理画面へ画面遷移すること' do
        visit admin_login_path
        fill_in 'email', with: admin.email
        fill_in 'password', with: 'password'
        click_button 'Login'
        expect(page).to have_content('ようこそ！ログインしました！')
        expect(page).to have_content('管理者画面')
        expect(current_path).to eq(admin_root_path)
      end
    end
  end
end
