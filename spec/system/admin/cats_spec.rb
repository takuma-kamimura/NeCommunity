require 'rails_helper'

RSpec.describe "Admin::Cats", type: :system do
  let!(:general1) { create(:user, :general)}
  let!(:general2) { create(:user, :general)}
  let!(:general3) { create(:user, :general)}
  let!(:admin) { create(:user, :admin)}

  let!(:cat_breed) {create(:cat_breed)}

  let!(:cat1) { create(:cat, user: general1, cat_breed: cat_breed) }
  let!(:cat2) { create(:cat, user: general2, cat_breed: cat_breed) }
  let!(:cat3) { create(:cat, user: general3, cat_breed: cat_breed) }
  let!(:cat4) { create(:cat, user: admin, cat_breed: cat_breed) }
  before do
    login_process_admin(admin)
  end
  describe '管理画面の猫一覧テスト' do
    it '猫一覧が正常に表示されること' do
      click_link '猫管理'
      expect(page).to have_content('猫一覧')
      expect(page).to have_content(cat1.name)
      expect(page).to have_content(general1.name)
      expect(page).to have_content(cat1.self_introduction)
      expect(page).to have_content(cat2.name)
      expect(page).to have_content(general2.name)
      expect(page).to have_content(cat2.self_introduction)
      expect(page).to have_content(cat3.name)
      expect(page).to have_content(general3.name)
      expect(page).to have_content(cat3.self_introduction)
      expect(page).to have_content(cat4.name)
      expect(page).to have_content(admin.name)
      expect(page).to have_content(cat4.self_introduction)
    end
    context '編集・更新・削除テスト' do
      it '猫の名前が空の場合更新ができずエラーメッセージが表示されること' do
        click_link '猫管理'
        click_link "編集", id: "admin-cat-edit-id-#{cat1.id}"
        expect(page).to have_content("#{cat1.decorate.cat_name}の編集ページ")
        expect(page).to have_content(cat1.name)
        expect(page).to have_content(general1.name)
        expect(page).to have_content(cat1.self_introduction)
        expect(page).to have_content('女の子')
        expect(page).to have_content(cat_breed.name)
        expect(current_path).to eq(edit_admin_cat_path(cat1))

        fill_in 'cat[name]', with: nil
        click_button '猫を更新する'
        expect(page).to have_content('管理者用：更新が失敗しました')
        expect(current_path).to eq(edit_admin_cat_path(cat1))
      end
      it '猫の名前が16文字以上の場合更新ができずエラーメッセージが表示されること' do
        click_link '猫管理'
        click_link "編集", id: "admin-cat-edit-id-#{cat1.id}"
        expect(page).to have_content("#{cat1.decorate.cat_name}の編集ページ")
        expect(page).to have_content(cat1.name)
        expect(page).to have_content(general1.name)
        expect(page).to have_content(cat1.self_introduction)
        expect(page).to have_content('女の子')
        expect(page).to have_content(cat_breed.name)
        expect(current_path).to eq(edit_admin_cat_path(cat1))

        fill_in 'cat[name]', with: 'a' * 16
        click_button '猫を更新する'
        expect(page).to have_content('管理者用：更新が失敗しました')
        expect(current_path).to eq(edit_admin_cat_path(cat1))
      end
      it '猫の紹介が201文字以上の場合更新ができずエラーメッセージが表示されること' do
        click_link '猫管理'
        click_link "編集", id: "admin-cat-edit-id-#{cat1.id}"
        expect(page).to have_content("#{cat1.decorate.cat_name}の編集ページ")
        expect(page).to have_content(cat1.name)
        expect(page).to have_content(general1.name)
        expect(page).to have_content(cat1.self_introduction)
        expect(page).to have_content('女の子')
        expect(page).to have_content(cat_breed.name)
        expect(current_path).to eq(edit_admin_cat_path(cat1))

        fill_in 'cat[self_introduction]', with: 'a' * 201
        click_button '猫を更新する'
        expect(page).to have_content('管理者用：更新が失敗しました')
        expect(current_path).to eq(edit_admin_cat_path(cat1))
      end
      it '猫を編集して更新ができること' do
        click_link '猫管理'
        click_link "編集", id: "admin-cat-edit-id-#{cat1.id}"
        expect(page).to have_content("#{cat1.decorate.cat_name}の編集ページ")
        expect(page).to have_content(cat1.name)
        expect(page).to have_content(general1.name)
        expect(page).to have_content(cat1.self_introduction)
        expect(page).to have_content('女の子')
        expect(page).to have_content(cat_breed.name)
        expect(current_path).to eq(edit_admin_cat_path(cat1))

        fill_in 'cat[name]', with: 'a' * 15
        select general2.name, from: 'cat_user_id'
        fill_in 'cat[self_introduction]', with: 'a' * 200
        fill_in 'cat[birthday]', with: '0714-2016'
        click_button '猫を更新する'
        expect(page).to have_content('管理者用：更新が成功しました')
        expect(current_path).to eq(admin_cats_path)

        click_link "詳細", id: "admin-cat-show-id-#{cat1.id}"
        expect(page).to have_content("#{'a' * 15}ちゃんの詳細画面")
        expect(page).to have_content("#{'a' * 200}")
        expect(page).to have_content('2016年07月14日')
        cat_create_datetime = cat1.created_at.strftime('%Y年%m月%d日 %H時%M分')
        expect(page).to have_content(cat_create_datetime)
      end
      it '猫のアバター画像を設定して更新ができること' do
        click_link '猫管理'
        click_link "編集", id: "admin-cat-edit-id-#{cat1.id}"
        expect(page).to have_content("#{cat1.decorate.cat_name}の編集ページ")
        expect(page).to have_content(cat1.name)
        expect(page).to have_content(general1.name)
        expect(page).to have_content(cat1.self_introduction)
        expect(page).to have_content('女の子')
        expect(page).to have_content(cat_breed.name)
        expect(current_path).to eq(edit_admin_cat_path(cat1))

        fill_in 'cat[name]', with: 'a' * 15
        select general2.name, from: 'cat_user_id'
        fill_in 'cat[self_introduction]', with: 'a' * 200
        fill_in 'cat[birthday]', with: '0714-2016'
        image_path = Rails.root.join('spec/images/test-cat-photo.webp')
        attach_file 'avatar-file', image_path
        click_button '猫を更新する'
        sleep 5
        expect(page).to have_content('管理者用：更新が成功しました')
        expect(current_path).to eq(admin_cats_path)

        click_link "詳細", id: "admin-cat-show-id-#{cat1.id}"
        expect(page).to have_content("#{'a' * 15}ちゃんの詳細画面")
        expect(page).to have_content("#{'a' * 200}")
        expect(page).to have_content('2016年07月14日')
        cat_create_datetime = cat1.created_at.strftime('%Y年%m月%d日 %H時%M分')
        expect(page).to have_content(cat_create_datetime)
        expect(page).to have_selector("img[src$='test-cat-photo.webp']")
      end
      it '設定してある猫のアバター画像を解除できること' do
        click_link '猫管理'
        click_link "編集", id: "admin-cat-edit-id-#{cat1.id}"
        expect(page).to have_content("#{cat1.decorate.cat_name}の編集ページ")
        expect(page).to have_content(cat1.name)
        expect(page).to have_content(general1.name)
        expect(page).to have_content(cat1.self_introduction)
        expect(page).to have_content('女の子')
        expect(page).to have_content(cat_breed.name)
        expect(current_path).to eq(edit_admin_cat_path(cat1))

        fill_in 'cat[name]', with: 'a' * 15
        select general2.name, from: 'cat_user_id'
        fill_in 'cat[self_introduction]', with: 'a' * 200
        fill_in 'cat[birthday]', with: '0714-2016'
        image_path = Rails.root.join('spec/images/test-cat-photo.webp')
        attach_file 'avatar-file', image_path
        click_button '猫を更新する'
        sleep 5
        expect(page).to have_content('管理者用：更新が成功しました')
        expect(current_path).to eq(admin_cats_path)

        click_link "編集", id: "admin-cat-edit-id-#{cat1.id}"
        check 'cat[remove_cat_avatar]'
        click_button '猫を更新する'
        sleep 5
        expect(page).to have_content('管理者用：更新が成功しました')
        click_link "詳細", id: "admin-cat-show-id-#{cat1.id}"
        expect(page).to have_content("#{'a' * 15}ちゃんの詳細画面")
        expect(page).to have_content("#{'a' * 200}")
        expect(page).to have_content('2016年07月14日')
        cat_create_datetime = cat1.created_at.strftime('%Y年%m月%d日 %H時%M分')
        expect(page).to have_content(cat_create_datetime)
        expect(page).not_to have_selector("img[src$='test-cat-photo.webp']")
      end
    end
  end
  describe '管理画面の猫詳細テスト' do
    it '猫の詳細ページが正常に表示されること' do
      click_link '猫管理'
      click_link "詳細", id: "admin-cat-show-id-#{cat1.id}"
      sleep 1
      expect(page).to have_content("#{cat1.decorate.cat_name}の詳細画面")
      expect(page).to have_content(general1.name)
      expect(page).to have_content(cat_breed.name)
      expect(page).to have_content(cat1.name)
      expect(page).to have_content(cat1.self_introduction)
      expect(page).to have_content('女の子')
      cat_create_datetime = cat1.created_at.strftime('%Y年%m月%d日 %H時%M分')
      expect(page).to have_content(cat_create_datetime)
      expect(current_path).to eq(admin_cat_path(cat1))
    end
    context '編集・更新・削除テスト' do
      it '猫の名前が空の場合更新ができずエラーメッセージが表示されること' do
        click_link '猫管理'
        click_link "詳細", id: "admin-cat-show-id-#{cat1.id}"

        click_link "編集"
        expect(page).to have_content("#{cat1.decorate.cat_name}の編集ページ")
        expect(page).to have_content(cat1.name)
        expect(page).to have_content(general1.name)
        expect(page).to have_content(cat1.self_introduction)
        expect(page).to have_content('女の子')
        expect(page).to have_content(cat_breed.name)
        expect(current_path).to eq(edit_admin_cat_path(cat1))

        fill_in 'cat[name]', with: nil
        click_button '猫を更新する'
        expect(page).to have_content('管理者用：更新が失敗しました')
        expect(current_path).to eq(edit_admin_cat_path(cat1))
      end
      it '猫の名前が16文字以上の場合更新ができずエラーメッセージが表示されること' do
        click_link '猫管理'
        click_link "詳細", id: "admin-cat-show-id-#{cat1.id}"

        click_link "編集"
        expect(page).to have_content("#{cat1.decorate.cat_name}の編集ページ")
        expect(page).to have_content(cat1.name)
        expect(page).to have_content(general1.name)
        expect(page).to have_content(cat1.self_introduction)
        expect(page).to have_content('女の子')
        expect(page).to have_content(cat_breed.name)
        expect(current_path).to eq(edit_admin_cat_path(cat1))

        fill_in 'cat[name]', with: 'a' * 16
        click_button '猫を更新する'
        expect(page).to have_content('管理者用：更新が失敗しました')
        expect(current_path).to eq(edit_admin_cat_path(cat1))
      end
      it '猫の紹介が201文字以上の場合更新ができずエラーメッセージが表示されること' do
        click_link '猫管理'
        click_link "詳細", id: "admin-cat-show-id-#{cat1.id}"

        click_link "編集"
        expect(page).to have_content("#{cat1.decorate.cat_name}の編集ページ")
        expect(page).to have_content(cat1.name)
        expect(page).to have_content(general1.name)
        expect(page).to have_content(cat1.self_introduction)
        expect(page).to have_content('女の子')
        expect(page).to have_content(cat_breed.name)
        expect(current_path).to eq(edit_admin_cat_path(cat1))

        fill_in 'cat[self_introduction]', with: 'a' * 201
        click_button '猫を更新する'
        expect(page).to have_content('管理者用：更新が失敗しました')
        expect(current_path).to eq(edit_admin_cat_path(cat1))
      end
      it '猫を編集して更新ができること' do
        click_link '猫管理'
        click_link "詳細", id: "admin-cat-show-id-#{cat1.id}"

        click_link "編集"
        expect(page).to have_content("#{cat1.decorate.cat_name}の編集ページ")
        expect(page).to have_content(cat1.name)
        expect(page).to have_content(general1.name)
        expect(page).to have_content(cat1.self_introduction)
        expect(page).to have_content('女の子')
        expect(page).to have_content(cat_breed.name)
        expect(current_path).to eq(edit_admin_cat_path(cat1))

        fill_in 'cat[name]', with: 'a' * 15
        select general2.name, from: 'cat_user_id'
        fill_in 'cat[self_introduction]', with: 'a' * 200
        fill_in 'cat[birthday]', with: '0714-2016'
        click_button '猫を更新する'
        expect(page).to have_content('管理者用：更新が成功しました')
        expect(current_path).to eq(admin_cats_path)

        click_link "詳細", id: "admin-cat-show-id-#{cat1.id}"
        expect(page).to have_content("#{'a' * 15}ちゃんの詳細画面")
        expect(page).to have_content("#{'a' * 200}")
        expect(page).to have_content('2016年07月14日')
        cat_create_datetime = cat1.created_at.strftime('%Y年%m月%d日 %H時%M分')
        expect(page).to have_content(cat_create_datetime)
      end
      it '猫のアバター画像を設定して更新ができること' do
        click_link '猫管理'
        click_link "詳細", id: "admin-cat-show-id-#{cat1.id}"

        click_link "編集"
        expect(page).to have_content("#{cat1.decorate.cat_name}の編集ページ")
        expect(page).to have_content(cat1.name)
        expect(page).to have_content(general1.name)
        expect(page).to have_content(cat1.self_introduction)
        expect(page).to have_content('女の子')
        expect(page).to have_content(cat_breed.name)
        expect(current_path).to eq(edit_admin_cat_path(cat1))

        fill_in 'cat[name]', with: 'a' * 15
        select general2.name, from: 'cat_user_id'
        fill_in 'cat[self_introduction]', with: 'a' * 200
        fill_in 'cat[birthday]', with: '0714-2016'
        image_path = Rails.root.join('spec/images/test-cat-photo.webp')
        attach_file 'avatar-file', image_path
        click_button '猫を更新する'
        sleep 5
        expect(page).to have_content('管理者用：更新が成功しました')
        expect(current_path).to eq(admin_cats_path)

        click_link "詳細", id: "admin-cat-show-id-#{cat1.id}"
        expect(page).to have_content("#{'a' * 15}ちゃんの詳細画面")
        expect(page).to have_content("#{'a' * 200}")
        expect(page).to have_content('2016年07月14日')
        cat_create_datetime = cat1.created_at.strftime('%Y年%m月%d日 %H時%M分')
        expect(page).to have_content(cat_create_datetime)
        expect(page).to have_selector("img[src$='test-cat-photo.webp']")
      end
      it '設定してある猫のアバター画像を解除できること' do
        click_link '猫管理'
        click_link "詳細", id: "admin-cat-show-id-#{cat1.id}"

        click_link "編集"
        expect(page).to have_content("#{cat1.decorate.cat_name}の編集ページ")
        expect(page).to have_content(cat1.name)
        expect(page).to have_content(general1.name)
        expect(page).to have_content(cat1.self_introduction)
        expect(page).to have_content('女の子')
        expect(page).to have_content(cat_breed.name)
        expect(current_path).to eq(edit_admin_cat_path(cat1))

        fill_in 'cat[name]', with: 'a' * 15
        select general2.name, from: 'cat_user_id'
        fill_in 'cat[self_introduction]', with: 'a' * 200
        fill_in 'cat[birthday]', with: '0714-2016'
        image_path = Rails.root.join('spec/images/test-cat-photo.webp')
        attach_file 'avatar-file', image_path
        click_button '猫を更新する'
        sleep 5
        expect(page).to have_content('管理者用：更新が成功しました')
        expect(current_path).to eq(admin_cats_path)

        click_link "編集", id: "admin-cat-edit-id-#{cat1.id}"
        check 'cat[remove_cat_avatar]'
        click_button '猫を更新する'
        sleep 5
        expect(page).to have_content('管理者用：更新が成功しました')
        click_link "詳細", id: "admin-cat-show-id-#{cat1.id}"
        expect(page).to have_content("#{'a' * 15}ちゃんの詳細画面")
        expect(page).to have_content("#{'a' * 200}")
        expect(page).to have_content('2016年07月14日')
        cat_create_datetime = cat1.created_at.strftime('%Y年%m月%d日 %H時%M分')
        expect(page).to have_content(cat_create_datetime)
        expect(page).not_to have_selector("img[src$='test-cat-photo.webp']")
      end
    end
  end
end
