require 'rails_helper'

RSpec.describe "Admin::User_Sessions", type: :system do
  let!(:general1) { create(:user, :general)}
  let!(:general2) { create(:user, :general)}
  let!(:general3) { create(:user, :general)}
  let!(:admin) { create(:user, :admin)}
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
    context '入力に不備がある場合にログインに失敗し、エラーメッセージが表示されること' do
      it 'メールアドレスが間違い、或いは空欄の場合はエラーメッセージが表示されること' do
        visit admin_login_path
        fill_in 'email', with: 'faild@jp'
        fill_in 'password', with: 'password'
        click_button 'Login'
        expect(page).to have_content('申し訳ありません ログインに失敗しました')
        expect(page).to have_content('管理者ログインページ')
        expect(current_path).to eq(admin_login_path)

        visit admin_login_path
        fill_in 'email', with: nil
        fill_in 'password', with: 'password'
        click_button 'Login'
        expect(page).to have_content('申し訳ありません ログインに失敗しました')
        expect(page).to have_content('管理者ログインページ')
        expect(current_path).to eq(admin_login_path)
      end
    end
    context '入力に不備がある場合にログインに失敗し、エラーメッセージが表示されること' do
      it 'パスワードが間違い、或いは空欄の場合はエラーメッセージが表示されること' do
        visit admin_login_path
        fill_in 'email', with: admin.email
        fill_in 'password', with: 'pass'
        click_button 'Login'
        expect(page).to have_content('申し訳ありません ログインに失敗しました')
        expect(page).to have_content('管理者ログインページ')
        expect(current_path).to eq(admin_login_path)

        visit admin_login_path
        fill_in 'email', with: admin.email
        fill_in 'password', with: nil
        click_button 'Login'
        expect(page).to have_content('申し訳ありません ログインに失敗しました')
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
