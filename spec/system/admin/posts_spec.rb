require 'rails_helper'

RSpec.describe "Admin::Posts", type: :system do
  let!(:general1) { create(:user, :general)}
  let!(:general2) { create(:user, :general)}
  let!(:general3) { create(:user, :general)}
  let!(:admin) { create(:user, :admin)}

  let!(:cat_breed) {create(:cat_breed)}

  let!(:cat1) { create(:cat, user: general1, cat_breed: cat_breed) }
  let!(:cat2) { create(:cat, user: general2, cat_breed: cat_breed) }
  let!(:cat3) { create(:cat, user: general3, cat_breed: cat_breed) }
  let!(:cat4) { create(:cat, user: admin, cat_breed: cat_breed) }

  let!(:post1) { create(:post, user: general1, cat: cat1) }
  let!(:post2) { create(:post, user: general2, cat: cat2) }
  let!(:post3) { create(:post, user: general3, cat: cat3) }
  let!(:post4) { create(:post, user: admin) }
  
  before do
    login_process_admin(admin)
  end
  describe '管理画面の投稿一覧テスト' do
    it '投稿一覧が正常に表示されること' do
      click_link '投稿管理'
      expect(page).to have_content(general1.name)
      expect(page).to have_content(post1.title)
      expect(page).to have_content(post1.body)
      expect(page).to have_content(cat1.name)
      expect(page).to have_content(general2.name)
      expect(page).to have_content(post2.title)
      expect(page).to have_content(post2.body)
      expect(page).to have_content(cat2.name)
      expect(page).to have_content(general3.name)
      expect(page).to have_content(post3.title)
      expect(page).to have_content(post3.body)
      expect(page).to have_content(cat3.name)
      expect(page).to have_content(admin.name)
      expect(page).to have_content(post4.title)
      expect(page).to have_content(post4.body)
      expect(page).not_to have_content(cat4.name)
      expect(current_path).to eq(admin_posts_path)
    end
    context '編集・更新・削除テスト' do
      it 'タイトルが空の場合更新ができずエラーメッセージが表示されること' do
        click_link '投稿管理'
        click_link "編集", id: "admin-post-edit-id-#{post1.id}"
        expect(page).to have_content('投稿編集画面')
        expect(current_path).to eq(edit_admin_post_path(post1))

        fill_in 'post[title]', with: nil
        fill_in 'post[body]', with: 'body-edit'
        click_button '更新'
        expect(page).to have_content('管理者用：更新が失敗しました')
        expect(current_path).to eq(edit_admin_post_path(post1))
      end
      it 'タイトルが21文字以上の場合更新ができずエラーメッセージが表示されること' do
        click_link '投稿管理'
        click_link "編集", id: "admin-post-edit-id-#{post1.id}"
        expect(page).to have_content('投稿編集画面')
        expect(current_path).to eq(edit_admin_post_path(post1))

        fill_in 'post[title]', with: 'a' * 21
        fill_in 'post[body]', with: 'body-edit'
        click_button '更新'
        expect(page).to have_content('管理者用：更新が失敗しました')
        expect(current_path).to eq(edit_admin_post_path(post1))
      end
      it '投稿内容が空の場合更新ができずエラーメッセージが表示されること' do
        click_link '投稿管理'
        click_link "編集", id: "admin-post-edit-id-#{post1.id}"
        expect(page).to have_content('投稿編集画面')
        expect(current_path).to eq(edit_admin_post_path(post1))

        fill_in 'post[title]', with: 'title-edit'
        fill_in 'post[body]', with: nil
        click_button '更新'
        expect(page).to have_content('管理者用：更新が失敗しました')
        expect(current_path).to eq(edit_admin_post_path(post1))
      end
      it '投稿内容が501文字以上の場合更新ができずエラーメッセージが表示されること' do
        click_link '投稿管理'
        click_link "編集", id: "admin-post-edit-id-#{post1.id}"
        expect(page).to have_content('投稿編集画面')
        expect(current_path).to eq(edit_admin_post_path(post1))

        fill_in 'post[title]', with: 'title-edit'
        fill_in 'post[body]', with: 'a' * 501
        click_button '更新'
        expect(page).to have_content('管理者用：更新が失敗しました')
        expect(current_path).to eq(edit_admin_post_path(post1))
      end
      it '投稿を編集して更新ができること' do
        click_link '投稿管理'
        click_link "編集", id: "admin-post-edit-id-#{post1.id}"
        expect(page).to have_content('投稿編集画面')
        expect(current_path).to eq(edit_admin_post_path(post1))

        fill_in 'post[title]', with: 'title-edit'
        fill_in 'post[body]', with: 'body-edit'
        click_button '更新'
        sleep 1
        expect(page).to have_content('管理者用：更新が成功しました')
        expect(page).to have_content('title-edit')
        expect(page).to have_content('body-edit')
        expect(page).to have_content(general1.name)
        expect(page).to have_content(cat1.name)
        expect(current_path).to eq(admin_post_path(post1))
      end
      it '投稿に画像を添付し、編集して更新ができること' do
        click_link '投稿管理'
        click_link "編集", id: "admin-post-edit-id-#{post1.id}"
        expect(page).to have_content('投稿編集画面')
        expect(current_path).to eq(edit_admin_post_path(post1))

        fill_in 'post[title]', with: 'title-edit'
        fill_in 'post[body]', with: 'body-edit'
        image_path = Rails.root.join('spec/images/test-cat-photo.webp')
        attach_file 'avatar-file', image_path
        click_button '更新'
        sleep 1
        expect(page).to have_content('管理者用：更新が成功しました')
        expect(page).to have_content('title-edit')
        expect(page).to have_content('body-edit')
        expect(page).to have_content(general1.name)
        expect(page).to have_content(cat1.name)
        expect(current_path).to eq(admin_post_path(post1))
        expect(page).to have_selector("img[src$='test-cat-photo.webp']")
      end
      it '投稿の削除ができること' do
        click_link '投稿管理'
        expect(page).to have_content(post1.title)
        accept_alert do
          click_link "削除", id: "admin-post-delete-id-#{post1.id}"
        end
        expect(page).to have_content('管理者用：削除しました')
        expect(page).not_to have_content(post1.title)
        expect(current_path).to eq(admin_posts_path)
      end
    end
  end
  describe '管理画面の投稿詳細ページ表示テスト' do
    it '投稿詳細ページが正常に表示されること' do
      click_link '投稿管理'
      click_link "詳細", id: "admin-post-show-id-#{post1.id}"
      expect(page).to have_content('投稿詳細')
      expect(page).to have_content(post1.title)
      expect(page).to have_content(post1.body)
      expect(page).to have_content(general1.name)
      expect(page).to have_content(cat1.name)
      expect(current_path).to eq(admin_post_path(post1))
    end
  end
    context '編集・更新・削除テスト' do
      it 'タイトルが空の場合更新ができずエラーメッセージが表示されること' do
        click_link '投稿管理'
        click_link "詳細", id: "admin-post-show-id-#{post1.id}"
        expect(page).to have_content('投稿詳細')
        expect(page).to have_content(post1.title)
        expect(page).to have_content(post1.body)
        expect(page).to have_content(general1.name)
        expect(page).to have_content(cat1.name)
        expect(current_path).to eq(admin_post_path(post1))
        click_link "編集", id: "admin-post-for-show-edit-id-#{post1.id}"

        expect(page).to have_content('投稿編集画面')
        expect(current_path).to eq(edit_admin_post_path(post1))

        fill_in 'post[title]', with: nil
        fill_in 'post[body]', with: 'body-edit'
        click_button '更新'
        expect(page).to have_content('管理者用：更新が失敗しました')
        expect(current_path).to eq(edit_admin_post_path(post1))
      end
      it 'タイトルが21文字以上の場合更新ができずエラーメッセージが表示されること' do
        click_link '投稿管理'
        click_link "詳細", id: "admin-post-show-id-#{post1.id}"
        expect(page).to have_content('投稿詳細')
        expect(page).to have_content(post1.title)
        expect(page).to have_content(post1.body)
        expect(page).to have_content(general1.name)
        expect(page).to have_content(cat1.name)
        expect(current_path).to eq(admin_post_path(post1))
        click_link "編集", id: "admin-post-for-show-edit-id-#{post1.id}"

        expect(page).to have_content('投稿編集画面')
        expect(current_path).to eq(edit_admin_post_path(post1))

        fill_in 'post[title]', with: 'a' * 21
        fill_in 'post[body]', with: 'body-edit'
        click_button '更新'
        expect(page).to have_content('管理者用：更新が失敗しました')
        expect(current_path).to eq(edit_admin_post_path(post1))
      end
      it '投稿内容が空の場合更新ができずエラーメッセージが表示されること' do
        click_link '投稿管理'
        click_link "詳細", id: "admin-post-show-id-#{post1.id}"
        expect(page).to have_content('投稿詳細')
        expect(page).to have_content(post1.title)
        expect(page).to have_content(post1.body)
        expect(page).to have_content(general1.name)
        expect(page).to have_content(cat1.name)
        expect(current_path).to eq(admin_post_path(post1))
        click_link "編集", id: "admin-post-for-show-edit-id-#{post1.id}"

        expect(page).to have_content('投稿編集画面')
        expect(current_path).to eq(edit_admin_post_path(post1))

        fill_in 'post[title]', with: 'title-edit'
        fill_in 'post[body]', with: nil
        click_button '更新'
        expect(page).to have_content('管理者用：更新が失敗しました')
        expect(current_path).to eq(edit_admin_post_path(post1))
      end
      it '投稿内容が501文字以上の場合更新ができずエラーメッセージが表示されること' do
        click_link '投稿管理'
        click_link "詳細", id: "admin-post-show-id-#{post1.id}"
        expect(page).to have_content('投稿詳細')
        expect(page).to have_content(post1.title)
        expect(page).to have_content(post1.body)
        expect(page).to have_content(general1.name)
        expect(page).to have_content(cat1.name)
        expect(current_path).to eq(admin_post_path(post1))
        click_link "編集", id: "admin-post-for-show-edit-id-#{post1.id}"

        expect(page).to have_content('投稿編集画面')
        expect(current_path).to eq(edit_admin_post_path(post1))

        fill_in 'post[title]', with: 'title-edit'
        fill_in 'post[body]', with: 'a' * 501
        click_button '更新'
        expect(page).to have_content('管理者用：更新が失敗しました')
        expect(current_path).to eq(edit_admin_post_path(post1))
      end
      it '投稿を編集して更新ができること' do
        click_link '投稿管理'
        click_link "詳細", id: "admin-post-show-id-#{post1.id}"
        expect(page).to have_content('投稿詳細')
        expect(page).to have_content(post1.title)
        expect(page).to have_content(post1.body)
        expect(page).to have_content(general1.name)
        expect(page).to have_content(cat1.name)
        expect(current_path).to eq(admin_post_path(post1))
        click_link "編集", id: "admin-post-for-show-edit-id-#{post1.id}"

        expect(page).to have_content('投稿編集画面')
        expect(current_path).to eq(edit_admin_post_path(post1))

        fill_in 'post[title]', with: 'title-edit'
        fill_in 'post[body]', with: 'body-edit'
        click_button '更新'
        sleep 1
        expect(page).to have_content('管理者用：更新が成功しました')
        expect(page).to have_content('title-edit')
        expect(page).to have_content('body-edit')
        expect(page).to have_content(general1.name)
        expect(page).to have_content(cat1.name)
        expect(current_path).to eq(admin_post_path(post1))
      end
      it '投稿に画像を添付し、編集して更新ができること' do
        click_link '投稿管理'
        click_link "詳細", id: "admin-post-show-id-#{post1.id}"
        expect(page).to have_content('投稿詳細')
        expect(page).to have_content(post1.title)
        expect(page).to have_content(post1.body)
        expect(page).to have_content(general1.name)
        expect(page).to have_content(cat1.name)
        expect(current_path).to eq(admin_post_path(post1))
        click_link "編集", id: "admin-post-for-show-edit-id-#{post1.id}"

        expect(page).to have_content('投稿編集画面')
        expect(current_path).to eq(edit_admin_post_path(post1))

        fill_in 'post[title]', with: 'title-edit'
        fill_in 'post[body]', with: 'body-edit'
        image_path = Rails.root.join('spec/images/test-cat-photo.webp')
        attach_file 'avatar-file', image_path
        click_button '更新'
        sleep 1
        expect(page).to have_content('管理者用：更新が成功しました')
        expect(page).to have_content('title-edit')
        expect(page).to have_content('body-edit')
        expect(page).to have_content(general1.name)
        expect(page).to have_content(cat1.name)
        expect(current_path).to eq(admin_post_path(post1))
        expect(page).to have_selector("img[src$='test-cat-photo.webp']")
      end
      it '投稿の削除ができること' do
        click_link '投稿管理'
        click_link "詳細", id: "admin-post-show-id-#{post1.id}"
        expect(page).to have_content('投稿詳細')
        expect(page).to have_content(post1.title)
        expect(page).to have_content(post1.body)
        expect(page).to have_content(general1.name)
        expect(page).to have_content(cat1.name)
        expect(current_path).to eq(admin_post_path(post1))
        accept_alert do
          click_link "削除", id: "admin-post-for-show-delete-id-#{post1.id}"
        end
        expect(page).to have_content('管理者用：削除しました')
        expect(page).not_to have_content(post1.title)
        expect(current_path).to eq(admin_posts_path)
      end
    end
end
