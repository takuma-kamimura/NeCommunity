require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe 'ユーザー新規登録時のテスト' do
    before do
      visit root_path
      visit new_user_path
    end
    context '入力に不備がある場合に登録に失敗し、エラーメッセージが表示されること' do
      it "名前がない場合はエラーメッセージが表示されること" do
        fill_in 'user[name]', with: nil
        fill_in 'user[email]', with: 'test@email.com'
        fill_in 'user[password]', with: 'test'
        fill_in 'user[password_confirmation]', with: 'test'
        click_button 'Sign Up'
        expect(page).to have_content('申し訳ありません 新規登録に失敗しました')
        expect(page).to have_content('名前を入力してください')
        expect(current_path).to eq(new_user_path)

      end
    end
    context '入力に不備がある場合に登録に失敗し、エラーメッセージが表示されること' do
      it "名前が16文字以上の場合はエラーメッセージが表示されること" do
        fill_in 'user[name]', with: 'a' * 16
        fill_in 'user[email]', with: 'test@email.com'
        fill_in 'user[password]', with: 'test'
        fill_in 'user[password_confirmation]', with: 'test'
        click_button 'Sign Up'
        expect(page).to have_content('申し訳ありません 新規登録に失敗しました')
        expect(page).to have_content('名前は15文字以内で入力してください')
        expect(current_path).to eq(new_user_path)
      end
    end
    context '入力に不備がある場合に登録に失敗し、エラーメッセージが表示されること' do
      it "メールアドレスがない場合はエラーメッセージが表示されること" do
        fill_in 'user[name]', with: 'test'
        fill_in 'user[email]', with: nil
        fill_in 'user[password]', with: 'test'
        fill_in 'user[password_confirmation]', with: 'test'
        click_button 'Sign Up'
        expect(page).to have_content('申し訳ありません 新規登録に失敗しました')
        expect(page).to have_content('メールアドレスを入力してください')
        expect(current_path).to eq(new_user_path)
      end
    end
    context '入力に不備がある場合に登録に失敗し、エラーメッセージが表示されること' do
      it "パスワードがない場合はエラーメッセージが表示されること" do
        fill_in 'user[name]', with: 'test'
        fill_in 'user[email]', with: 'test@email.com'
        fill_in 'user[password]', with: nil
        fill_in 'user[password_confirmation]', with: 'test'
        click_button 'Sign Up'
        expect(page).to have_content('申し訳ありません 新規登録に失敗しました')
        expect(page).to have_content('パスワードを入力してください')
        expect(current_path).to eq(new_user_path)
      end
    end
    context '入力に不備がある場合に登録に失敗し、エラーメッセージが表示されること' do
      it "パスワード確認がない場合はエラーメッセージが表示されること" do
        fill_in 'user[name]', with: 'test'
        fill_in 'user[email]', with: 'test@email.com'
        fill_in 'user[password]', with: 'test'
        fill_in 'user[password_confirmation]', with: nil
        click_button 'Sign Up'
        expect(page).to have_content('申し訳ありません 新規登録に失敗しました')
        expect(page).to have_content('パスワード確認を入力してください')
        expect(current_path).to eq(new_user_path)
      end
    end
    context '入力に不備がある場合に登録に失敗し、エラーメッセージが表示されること' do
      it "パスワードが2文字以下の場合はエラーメッセージが表示されること" do
        fill_in 'user[name]', with: 'test'
        fill_in 'user[email]', with: 'test@email.com'
        fill_in 'user[password]', with: 'te'
        fill_in 'user[password_confirmation]', with: 'te'
        click_button 'Sign Up'
        expect(page).to have_content('申し訳ありません 新規登録に失敗しました')
        expect(page).to have_content('パスワードは3文字以上で入力してください')
        expect(current_path).to eq(new_user_path)
      end
    end
    context '入力内容が正常' do
      it "正常に登録されること" do
        fill_in 'user[name]', with: 'test'
        fill_in 'user[email]', with: 'test@email.com'
        fill_in 'user[password]', with: 'test'
        fill_in 'user[password_confirmation]', with: 'test'
        click_button 'Sign Up'
        expect(page).to have_content('新規登録が完了しました！')
        expect(current_path).to eq(root_path)
      end
    end
  end
end
