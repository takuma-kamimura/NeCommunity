require 'rails_helper'

RSpec.describe "Admin::Users::Users", type: :system do
  let!(:general1) { create(:user, :general)}
  let!(:general2) { create(:user, :general)}
  let!(:general3) { create(:user, :general)}
  let!(:admin) { create(:user, :admin)}
  before do
    login_process_admin(admin)
  end
  describe '管理画面のユーザー一覧表示テスト' do
    it 'ユーザーの一覧が表示されること' do
      expect(page).to have_content('ユーザー一覧')
      expect(page).to have_content(general1.name)
      expect(page).to have_content(general2.name)
      expect(page).to have_content(general3.name)
      expect(page).to have_content(admin.name)
      expect(current_path).to eq(admin_root_path)
    end
  end
  describe '管理画面の詳細ページ表示テスト' do
    let!(:general1) { create(:user, :general, self_introduction: 'test')}
    let!(:general2) { create(:user, :general, self_introduction: 'test')}
    it '一般ユーザーの詳細ページが正常に表示されること' do
      click_link general1.name
      sleep 2
      expect(current_path).to eq(admin_user_path(general1))
      expect(page).to have_content(general1.name)
      expect(page).to have_content(general1.email)
      expect(page).to have_content(general1.name)
      expect(page).to have_content(general1.self_introduction)
      expect(page).to have_content('Line登録済み')
      expect(page).to have_content('一般ユーザー')
      expect(page).to have_content('作成日')
      user_create_datetime = general1.created_at.strftime('%Y年%m月%d日 %H時%M分')
      expect(page).to have_content(user_create_datetime)
    end
    it '管理者ユーザーの詳細ページが正常に表示されること' do
      click_link admin.name
      sleep 2
      expect(current_path).to eq(admin_user_path(admin))
      expect(page).to have_content(admin.name)
      expect(page).to have_content(admin.email)
      expect(page).to have_content(admin.name)
      expect(page).to have_content(admin.self_introduction)
      expect(page).to have_content('Line登録済み')
      expect(page).to have_content('管理者')
      expect(page).to have_content('作成日')
      user_create_datetime = admin.created_at.strftime('%Y年%m月%d日 %H時%M分')
      expect(page).to have_content(user_create_datetime)
    end
  end
  describe '編集・更新・削除テスト' do
    let!(:general1) { create(:user, :general, self_introduction: 'test')}
    let!(:general2) { create(:user, :general)}
    it 'ユーザーの登録情報を更新できて一般ユーザーを管理者ユーザーへ変更可能なこと' do
      click_link general1.name
      sleep 2
      expect(current_path).to eq(admin_user_path(general1))
      expect(page).to have_content(general1.name)
      expect(page).to have_content(general1.email)
      expect(page).to have_content(general1.name)
      expect(page).to have_content(general1.self_introduction)
      expect(page).to have_content('Line登録済み')
      expect(page).to have_content('一般ユーザー')
      expect(page).to have_content('作成日')
      user_create_datetime = general1.created_at.strftime('%Y年%m月%d日 %H時%M分')
      expect(page).to have_content(user_create_datetime)

      click_link '編集'
      fill_in 'user[name]', with: 'test-name'
      fill_in 'user[email]', with: 'test@jp'
      fill_in 'user[self_introduction]', with: 'test-self_introduction'
      select '管理者', from: 'user_role'
      image_path = Rails.root.join('spec/images/test-cat-photo.webp')
      attach_file 'avatar-file', image_path
      click_button '更新'
      expect(page).to have_content('test-name')
      expect(page).to have_content('test@jp')
      expect(page).to have_content('test-self_introduction')
      expect(page).to have_selector("img[src$='test-cat-photo.webp']")
      expect(page).to have_content('管理者')
      expect(page).to have_content('作成日')
      expect(page).to have_content(user_create_datetime)
    end
    it 'ユーザーのアバター画像の解除が可能なこと' do
      click_link general1.name
      sleep 2
      expect(current_path).to eq(admin_user_path(general1))
      expect(page).to have_content(general1.name)
      expect(page).to have_content(general1.email)
      expect(page).to have_content(general1.name)
      expect(page).to have_content(general1.self_introduction)
      expect(page).to have_content('Line登録済み')
      expect(page).to have_content('一般ユーザー')
      expect(page).to have_content('作成日')
      user_create_datetime = general1.created_at.strftime('%Y年%m月%d日 %H時%M分')
      expect(page).to have_content(user_create_datetime)

      click_link '編集'
      fill_in 'user[name]', with: 'test-name'
      fill_in 'user[email]', with: 'test@jp'
      fill_in 'user[self_introduction]', with: 'test-self_introduction'
      select '管理者', from: 'user_role'
      image_path = Rails.root.join('spec/images/test-cat-photo.webp')
      attach_file 'avatar-file', image_path
      click_button '更新'
      expect(page).to have_selector("img[src$='test-cat-photo.webp']")
      
      click_link '編集'
      check 'user[remove_avatar]'
      click_button '更新'
      expect(page).not_to have_selector("img[src$='test-cat-photo.webp']")
    end
    it 'ユーザーのLineの登録情報を解除可能なこと' do
      click_link general1.name
      sleep 2
      expect(current_path).to eq(admin_user_path(general1))
      expect(page).to have_content(general1.name)
      expect(page).to have_content(general1.email)
      expect(page).to have_content(general1.name)
      expect(page).to have_content(general1.self_introduction)
      expect(page).to have_content('Line登録済み')
      expect(page).to have_content('一般ユーザー')
      expect(page).to have_content('作成日')
      user_create_datetime = general1.created_at.strftime('%Y年%m月%d日 %H時%M分')
      expect(page).to have_content(user_create_datetime)

      click_link '編集'
      check 'user[remove_line_id]'
      click_button '更新'
      expect(page).to have_content('Line未登録')
    end
    it '管理画面でユーザーの削除が可能なこと' do
      click_link general1.name
      sleep 2
      expect(current_path).to eq(admin_user_path(general1))
      expect(page).to have_content(general1.name)
      expect(page).to have_content(general1.email)
      expect(page).to have_content(general1.name)
      expect(page).to have_content(general1.self_introduction)
      expect(page).to have_content('Line登録済み')
      expect(page).to have_content('管理者')
      expect(page).to have_content('作成日')
      user_create_datetime = general1.created_at.strftime('%Y年%m月%d日 %H時%M分')
      expect(page).to have_content(user_create_datetime)

      accept_alert do
        click_link '削除'
      end
      expect(page).to have_content('管理者用：削除しました')
      expect(current_path).to eq(admin_users_path)
    end
  end
  describe '管理画面のユーザー一覧検索機能テスト' do
    let!(:general4) { create(:user, :general, name: '山田太郎', email: 'yamada@jp')}
    it '名前でユーザーの検索ができること' do
      expect(page).to have_content('ユーザー一覧')
      expect(page).to have_content(general1.name)
      expect(page).to have_content(general2.name)
      expect(page).to have_content(general3.name)
      expect(page).to have_content(admin.name)
      expect(page).to have_content('山田太郎')
      expect(current_path).to eq(admin_root_path)

      fill_in 'q_name_or_email_cont', with: '山'
      click_button '検索'
      expect(page).to have_content('山田太郎')
      expect(page).not_to have_content(general1.name)
      expect(page).not_to have_content(general2.name)
      expect(page).not_to have_content(general3.name)
      expect(page).not_to have_content(admin.name)
    end
    it 'メールアドレスでユーザーの検索ができること' do
      expect(page).to have_content('ユーザー一覧')
      expect(page).to have_content(general1.name)
      expect(page).to have_content(general2.name)
      expect(page).to have_content(general3.name)
      expect(page).to have_content(admin.name)
      expect(page).to have_content('山田太郎')
      expect(current_path).to eq(admin_root_path)

      fill_in 'q_name_or_email_cont', with: 'yamada'
      click_button '検索'
      expect(page).to have_content('山田太郎')
      expect(page).not_to have_content(general1.name)
      expect(page).not_to have_content(general2.name)
      expect(page).not_to have_content(general3.name)
      expect(page).not_to have_content(admin.name)
    end
  end
end
