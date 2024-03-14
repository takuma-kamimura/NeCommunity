require 'rails_helper'

RSpec.describe 'Profiles', type: :system do
  let(:user) { create(:user) }
  # before do
  #   login_process(user)
  #   visit posts_path
  #   find('#bars').click
  #   visit profile_path
  #   visit edit_profile_path
  # end
  describe 'ユーザープロフィール編集時のテスト' do
    before do
      login_process(user)
      visit posts_path
      find('#bars').click
      visit profile_path
      visit edit_profile_path
    end
    context '入力に不備がある場合に更新に失敗し、エラーメッセージが表示されること' do
      it '名前がない場合はエラーメッセージが表示されること' do
        fill_in 'user[name]', with: nil
        fill_in 'user[email]', with: 'test@email.com'
        fill_in 'user[self_introduction]', with: 'test-self_introduction'
        click_button 'Update'
        expect(page).to have_content('申し訳ありません プロフィールの更新に失敗しました')
        expect(page).to have_content('名前を入力してください')
        expect(current_path).to eq(edit_profile_path)
      end
    end
    context '入力に不備がある場合に更新に失敗し、エラーメッセージが表示されること' do
      it '名前が16文字以上の場合はエラーメッセージが表示されること' do
        fill_in 'user[name]', with: 'a' * 16
        fill_in 'user[email]', with: 'test@email.com'
        fill_in 'user[self_introduction]', with: 'test-self_introduction'
        click_button 'Update'
        expect(page).to have_content('申し訳ありません プロフィールの更新に失敗しました')
        expect(page).to have_content('名前は15文字以内で入力してください')
        expect(current_path).to eq(edit_profile_path)
      end
    end
    context '入力に不備がある場合に更新に失敗し、エラーメッセージが表示されること' do
      it 'メールアドレスがない場合はエラーメッセージが表示されること' do
        fill_in 'user[name]', with: 'test'
        fill_in 'user[email]', with: nil
        fill_in 'user[self_introduction]', with: 'test-self_introduction'
        click_button 'Update'
        expect(page).to have_content('申し訳ありません プロフィールの更新に失敗しました')
        expect(page).to have_content('メールアドレスを入力してください')
        expect(current_path).to eq(edit_profile_path)
      end
    end
    context '入力に不備がある場合に更新に失敗し、エラーメッセージが表示されること' do
      it '入力した内容が適切なメールアドレスでない場合は登録に失敗すること' do
        fill_in 'user[name]', with: 'test'
        fill_in 'user[email]', with: 'a' * 50
        fill_in 'user[self_introduction]', with: 'test-self_introduction'
        click_button 'Update'
        expect(current_path).to eq(edit_profile_path)
      end
    end
    context '入力に不備がある場合に更新に失敗し、エラーメッセージが表示されること' do
      it '自己紹介が201文字以上の場合はエラーメッセージが表示されること' do
        fill_in 'user[name]', with: 'test'
        fill_in 'user[email]', with: 'test@email.com'
        fill_in 'user[self_introduction]', with: 'a' * 201
        click_button 'Update'
        expect(page).to have_content('申し訳ありません プロフィールの更新に失敗しました')
        expect(page).to have_content('自己紹介は200文字以内で入力してください')
        expect(current_path).to eq(edit_profile_path)
      end
    end
    context '入力内容が正常' do
      it '正常に更新されること' do
        fill_in 'user[name]', with: 'test'
        fill_in 'user[email]', with: 'test@email.com'
        fill_in 'user[self_introduction]', with: 'test-self_introduction'
        click_button 'Update'
        expect(page).to have_content('プロフィールを更新しました')
        expect(page).to have_content('Profile Edit')
      end
    end
    context '入力内容が正常' do
      it '名前が15文字以内でかつ、正常に更新されること' do
        fill_in 'user[name]', with: 'a' * 15
        fill_in 'user[email]', with: 'test@email.com'
        fill_in 'user[self_introduction]', with: 'test-self_introduction'
        click_button 'Update'
        expect(page).to have_content('プロフィールを更新しました')
        expect(page).to have_content('Profile Edit')
      end
    end
    context '入力内容が正常' do
      it '自己紹介が200文字以内でかつ、正常に更新されること' do
        fill_in 'user[name]', with: 'test'
        fill_in 'user[email]', with: 'test@email.com'
        fill_in 'user[self_introduction]', with: 'a' * 200
        click_button 'Update'
        expect(page).to have_content('プロフィールを更新しました')
        expect(page).to have_content('Profile Edit')
      end
    end
    context '入力内容が正常' do
      it 'ユーザーのアバター画像を設定できること' do
        fill_in 'user[name]', with: 'test'
        fill_in 'user[email]', with: 'test@email.com'
        fill_in 'user[self_introduction]', with: 'a' * 200
        image_path = Rails.root.join('spec/images/test-cat-photo.webp')
        attach_file 'avatar-file', image_path
        click_button 'Update'
        expect(page).to have_content('プロフィールを更新しました')
        expect(page).to have_content('Profile Edit')
        expect(page).to have_selector("img[src$='test-cat-photo.webp']")
      end
    end
    context '入力内容が正常' do
      it '設定したユーザーのアバター画像を解除できること' do
        fill_in 'user[name]', with: 'test'
        fill_in 'user[email]', with: 'test@email.com'
        fill_in 'user[self_introduction]', with: 'a' * 200
        image_path = Rails.root.join('spec/images/test-cat-photo.webp')
        attach_file 'avatar-file', image_path
        click_button 'Update'
        expect(page).to have_content('プロフィールを更新しました')
        expect(page).to have_content('Profile Edit')
        expect(page).to have_selector("img[src$='test-cat-photo.webp']")
        visit edit_profile_path
        check 'user[remove_avatar]'
        click_button 'Update'
        expect(page).to have_content('プロフィールを更新しました')
        expect(page).not_to have_selector("img[src$='test-cat-photo.webp']")
        selector = "img[src*='kkrn_icon_user'][src*='.webp']"
        expect(page).to have_selector(selector)
      end
    end
  end
  describe 'ユーザーの退会処理のテスト' do
    context '退会処理が正常' do
      before do
        login_process(user)
        visit posts_path
        find('#bars').click
        visit profile_path
        visit edit_profile_path
      end
      it 'ユーザーが退会できること' do
        click_link '退会'
        expect(page).to have_content('あなたの全てのデータが削除されます！')
        expect(current_path).to eq(delete_confirmation_profile_path)
        accept_alert do
          click_link '退会'
        end
        sleep 2
        expect(current_path).to eq(root_path)
        expect(page).to have_content('退会処理が完了しました。またのご利用をお待ちしております！ありがとうございました！')
        login_process(user)
        expect(page).to have_content('申し訳ありません ログインに失敗しました')
      end
    end
    context '退会処理が正常' do
      let!(:admin) { create(:user, :admin)}
      before do
        login_process(admin)
        visit posts_path
        find('#bars').click
        visit profile_path
        visit edit_profile_path
      end
      it '管理者ユーザーは退会できないこと' do
        click_link '退会'
        expect(page).to have_content('あなたの全てのデータが削除されます！')
        expect(current_path).to eq(delete_confirmation_profile_path)
        accept_alert do
          click_link '退会'
        end
        sleep 2
        expect(current_path).to eq(delete_confirmation_profile_path)
        expect(page).to have_content('管理者ユーザーは退会できません！')
        visit profile_path
        expect(page).to have_content(admin.name)
        expect(page).to have_content(admin.email)
      end
    end
  end
end
