require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  let(:user) { create(:user) }
  describe 'ユーザーのログインテスト' do
    context '入力内容が正常' do
      it "正常にログインができ、投稿一覧へ画面遷移すること" do
        visit login_path
        fill_in 'email', with: user.email
        fill_in 'password', with: 'password'
        click_button 'Login'
        expect(page).to have_content('ようこそ！ログインしました！')
        expect(current_path).to eq(posts_path)
      end
    end
    context '入力に不備がある場合にログインに失敗し、エラーメッセージが表示されること' do
      it "メールアドレスがない場合はエラーメッセージが表示されること" do
        visit login_path
        fill_in 'email', with: nil
        fill_in 'password', with: 'password'
        click_button 'Login'
        expect(page).to have_content('申し訳ありません ログインに失敗しました')
        expect(current_path).to eq(login_path)
      end
    end
    context '入力に不備がある場合にログインに失敗し、エラーメッセージが表示されること' do
      it "パスワードがない場合はエラーメッセージが表示されること" do
        visit login_path
        fill_in 'email', with: user.email
        fill_in 'password', with: nil
        click_button 'Login'
        expect(page).to have_content('申し訳ありません ログインに失敗しました')
        expect(current_path).to eq(login_path)
      end
    end
    context '入力に間違いがある場合にログインに失敗し、エラーメッセージが表示されること' do
      it "メールアドレスが間違い、或いは存在しない場合はエラーメッセージが表示されること" do
        visit login_path
        fill_in 'email', with: 'tst@email.com'
        fill_in 'password', with: 'password'
        click_button 'Login'
        expect(page).to have_content('申し訳ありません ログインに失敗しました')
        expect(current_path).to eq(login_path)
      end
    end
    context '入力に間違いがある場合にログインに失敗し、エラーメッセージが表示されること' do
      it "パスワードが違う場合はエラーメッセージが表示されること" do
        visit login_path
        fill_in 'email', with: user.email
        fill_in 'password', with: 'passwoad'
        click_button 'Login'
        expect(page).to have_content('申し訳ありません ログインに失敗しました')
        expect(current_path).to eq(login_path)
      end
    end
  end
  describe 'ユーザーのログアウトテスト' do
    context 'ログアウト処理が正常' do
      it "ログインした後、正常にログアウトができること" do
        visit login_path
        fill_in 'email', with: user.email
        fill_in 'password', with: 'password'
        click_button 'Login'
        expect(page).to have_content('ようこそ！ログインしました！')
        expect(current_path).to eq(posts_path)
        find('#bars').click
        accept_alert do
          click_link('Logout')
        end
        expect(page).to have_content('ログアウトしました')
        expect(current_path).to eq(root_path)
      end
    end
  end
end
