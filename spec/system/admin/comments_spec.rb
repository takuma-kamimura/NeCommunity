require 'rails_helper'

RSpec.describe "Admin::Comments", type: :system do
  let!(:general1) { create(:user, :general)}
  let!(:general2) { create(:user, :general)}
  let!(:general3) { create(:user, :general)}
  let!(:admin) { create(:user, :admin)}

  let!(:cat_breed) {create(:cat_breed)}
  let!(:cat1) { create(:cat, user: general1, cat_breed: cat_breed) }
  let!(:post1) { create(:post, user: general1, cat: cat1) }

  let!(:comment1) { create(:comment, user: general2, post: post1) }
  let!(:comment2) { create(:comment, user: general3, post: post1) }
  let!(:comment3) { create(:comment, user: admin, post: post1) }

  before do
    login_process_admin(admin)
  end
  describe '管理画面のコメント投稿一覧テスト' do
    it 'コメント投稿一覧が正常に表示されること' do
      click_link 'コメント管理'
      expect(page).to have_content(post1.title)
      expect(page).to have_content(comment1.body)
      expect(page).to have_content(general2.name)
      expect(page).to have_content(post1.title)
      expect(page).to have_content(comment2.body)
      expect(page).to have_content(general3.name)
      expect(page).to have_content(post1.title)
      expect(page).to have_content(comment3.body)
      expect(page).to have_content(admin.name)
      expect(current_path).to eq(admin_comments_path)
    end
    context '編集・更新・削除テスト' do
      it 'コメントが空の場合更新ができずエラーメッセージが表示されること' do
        click_link 'コメント管理'
        click_link "編集", id: "admin-comment-edit-id-#{comment1.id}"
        expect(page).to have_content('コメント編集画面')
        expect(page).to have_content(comment1.body)
        expect(current_path).to eq(edit_admin_comment_path(comment1))

        fill_in 'comment[body]', with: nil
        click_button 'コメント更新'
        expect(page).to have_content('管理者用：更新が失敗しました')
        expect(current_path).to eq(edit_admin_comment_path(comment1))
      end
      it 'コメントが501文字以上の場合更新ができずエラーメッセージが表示されること' do
        click_link 'コメント管理'
        click_link "編集", id: "admin-comment-edit-id-#{comment1.id}"
        expect(page).to have_content('コメント編集画面')
        expect(page).to have_content(comment1.body)
        expect(current_path).to eq(edit_admin_comment_path(comment1))

        fill_in 'comment[body]', with: 'a' * 501
        click_button 'コメント更新'
        expect(page).to have_content('管理者用：更新が失敗しました')
        expect(current_path).to eq(edit_admin_comment_path(comment1))
      end
      it 'コメントを編集して更新ができること' do
        click_link 'コメント管理'
        click_link "編集", id: "admin-comment-edit-id-#{comment1.id}"
        expect(page).to have_content('コメント編集画面')
        expect(page).to have_content(comment1.body)
        expect(current_path).to eq(edit_admin_comment_path(comment1))

        fill_in 'comment[body]', with: 'comment-edit-body'
        click_button 'コメント更新'
        expect(page).to have_content('管理者用：更新が成功しました')
        expect(page).to have_content('コメント詳細')
        expect(page).to have_content(general2.name)
        expect(page).to have_content(post1.title)
        expect(page).to have_content('comment-edit-body')
        expect(page).not_to have_content(comment1.body)
        expect(current_path).to eq(admin_comment_path(comment1))
      end
      it 'コメントが削除できること' do
        click_link 'コメント管理'
        accept_alert do
          click_link "削除", id: "admin-comment-delete-id-#{comment1.id}"
        end
        expect(page).to have_content('管理者用：削除しました')
        expect(page).not_to have_content(comment1.body)
        expect(current_path).to eq(admin_comments_path)
      end
    end
  end


  describe '管理画面のコメント詳細テスト' do
    it 'コメント投稿詳細ページが正常に表示されること' do
      click_link 'コメント管理'
      click_link "詳細", id: "admin-comment-show-id-#{comment1.id}"

      expect(page).to have_content('コメント詳細')
      expect(page).to have_link(general2.name)
      expect(page).to have_link(post1.title)
      expect(page).to have_content(comment1.body)
    end
    it 'コメント投稿詳細ページからコメント投稿ユーザーのリンクへアクセスしてユーザーの情報が正常に表示されること' do
      click_link 'コメント管理'
      click_link "詳細", id: "admin-comment-show-id-#{comment1.id}"

      expect(page).to have_content('コメント詳細')
      expect(page).to have_link(general2.name)
      expect(page).to have_link(post1.title)
      expect(page).to have_content(comment1.body)

      click_link general2.name
      sleep 1
      expect(current_path).to eq(admin_user_path(general2))
      expect(page).to have_content('ユーザー詳細')
      expect(page).to have_content(general2.name)
      expect(page).to have_content(general2.email)
      expect(page).to have_content(general2.name)
      expect(page).to have_content(general2.self_introduction)
      expect(page).to have_content('Line登録済み')
      expect(page).to have_content('一般ユーザー')
      expect(page).to have_content('作成日')
    end
    it 'コメント投稿詳細ページからコメントを行った投稿のリンクへアクセスして投稿詳細ページが正常に表示されること' do
      click_link 'コメント管理'
      click_link "詳細", id: "admin-comment-show-id-#{comment1.id}"

      expect(page).to have_content('コメント詳細')
      expect(page).to have_link(general2.name)
      expect(page).to have_link(post1.title)
      expect(page).to have_content(comment1.body)

      click_link post1.title
      sleep 1
      expect(current_path).to eq(admin_post_path(post1))
      expect(page).to have_content('投稿詳細')
      expect(page).to have_content(post1.title)
      expect(page).to have_content(post1.body)
      expect(page).to have_content(cat1.name)
      expect(page).to have_content(general1.name)
    end
    context '編集・更新・削除テスト' do
      it 'コメントが空の場合更新ができずエラーメッセージが表示されること' do
        click_link 'コメント管理'
        click_link "詳細", id: "admin-comment-show-id-#{comment1.id}"
        click_link "編集"
        expect(page).to have_content('コメント編集画面')
        expect(page).to have_content(comment1.body)
        expect(current_path).to eq(edit_admin_comment_path(comment1))

        fill_in 'comment[body]', with: nil
        click_button 'コメント更新'
        expect(page).to have_content('管理者用：更新が失敗しました')
        expect(current_path).to eq(edit_admin_comment_path(comment1))
      end
      it 'コメントが501文字以上の場合更新ができずエラーメッセージが表示されること' do
        click_link 'コメント管理'
        click_link "詳細", id: "admin-comment-show-id-#{comment1.id}"
        click_link "編集"
        expect(page).to have_content('コメント編集画面')
        expect(page).to have_content(comment1.body)
        expect(current_path).to eq(edit_admin_comment_path(comment1))

        fill_in 'comment[body]', with: 'a' * 501
        click_button 'コメント更新'
        expect(page).to have_content('管理者用：更新が失敗しました')
        expect(current_path).to eq(edit_admin_comment_path(comment1))
      end
      it 'コメントを編集して更新ができること' do
        click_link 'コメント管理'
        click_link "詳細", id: "admin-comment-show-id-#{comment1.id}"
        click_link "編集"
        expect(page).to have_content('コメント編集画面')
        expect(page).to have_content(comment1.body)
        expect(current_path).to eq(edit_admin_comment_path(comment1))

        fill_in 'comment[body]', with: 'comment-edit-body'
        click_button 'コメント更新'
        expect(page).to have_content('管理者用：更新が成功しました')
        expect(page).to have_content('コメント詳細')
        expect(page).to have_content(general2.name)
        expect(page).to have_content(post1.title)
        expect(page).to have_content('comment-edit-body')
        expect(page).not_to have_content(comment1.body)
        expect(current_path).to eq(admin_comment_path(comment1))
      end
      it 'コメントが削除できること' do
        click_link 'コメント管理'
        click_link "詳細", id: "admin-comment-show-id-#{comment1.id}"
        accept_alert do
          click_link "削除"
        end
        expect(page).to have_content('管理者用：削除しました')
        expect(page).not_to have_content(comment1.body)
        expect(current_path).to eq(admin_comments_path)
      end
    end
  end
end
