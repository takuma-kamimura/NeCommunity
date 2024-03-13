require 'rails_helper'

RSpec.describe 'Likes', type: :system do
  describe 'ログイン・ログアウト状態の投稿一覧画面・投稿詳細画面の「いいね」ボタン表示テスト' do
    let(:user) { create(:user) }
    let!(:another_user) { create(:user) }
    let!(:post) { create(:post, user: another_user) }
    before do
      visit root_path
      visit posts_path
    end
    context 'ログアウト状態の投稿一覧画面の場合' do
      it '投稿一覧画面でいいねボタンが表示されず、いいねアイコンが表示されること' do
        expect(page).not_to have_css("#like-button-for-post-#{post.id}")
        expect(page).to have_css("#like-before-login-for-post-#{post.id}")
      end
    end
    context 'ログイン状態の投稿一覧画面の場合' do
      it '投稿一覧画面でいいねアイコンが表示されず、いいねボタンが表示されること' do
        login_process(user)
        visit root_path
        visit posts_path
        expect(page).not_to have_css("#like-before-login-for-post-#{post.id}")
        expect(page).to have_css("#like-button-for-post-#{post.id}")
      end
    end
    context 'ログアウト状態の投稿一覧画面の場合' do
      it '投稿一覧画面でいいねボタンが表示されず、いいねアイコンが表示されること' do
        visit post_path(post)
        expect(page).not_to have_css("#like-button-for-post-#{post.id}")
        expect(page).to have_css("#like-before-login-for-post-#{post.id}")
      end
    end
    context 'ログイン状態の投稿一覧画面の場合' do
      it '投稿一覧画面でいいねアイコンが表示されず、いいねボタンが表示されること' do
        login_process(user)
        visit root_path
        visit posts_path
        visit post_path(post)
        expect(page).not_to have_css("#like-before-login-for-post-#{post.id}")
        expect(page).to have_css("#like-button-for-post-#{post.id}")
      end
    end
  end

  describe '投稿一覧画面でのいいねの作成・削除テスト' do
    let!(:user) { create(:user) }
    let!(:like_user) { create(:user) }
    let!(:like_post) { create(:post, user: like_user) }
    let!(:delete_like_post) { create(:post, user: like_user) }
    let!(:like) { create(:like, user: user, post: delete_like_post) }
    before do
      login_process(user)
      visit root_path
      visit posts_path
    end
    it '投稿一覧画面で投稿にいいねができること' do
      find("#like-button-for-post-#{like_post.id}").click
      find("#like-button-for-post-#{like_post.id}").click
      expect(page).not_to have_css("#like-button-for-post-#{like_post.id}")
      expect(page).to have_css("#unlike-button-for-post-#{like_post.id}")
    end
    it '投稿一覧画面で投稿につけたいいねを削除できること' do
      find("#unlike-button-for-post-#{like.post.id}").click
      find("#unlike-button-for-post-#{like.post.id}").click
      expect(page).not_to have_css("#unlike-button-for-post-#{delete_like_post.id}")
      expect(page).to have_css("#like-button-for-post-#{delete_like_post.id}")
    end
  end
  describe '投稿詳細画面でのいいねの作成・削除テスト' do
    let!(:user) { create(:user) }
    let!(:like_user) { create(:user) }
    let!(:like_post) { create(:post, user: like_user) }
    let!(:delete_like_post) { create(:post, user: like_user) }
    let!(:like) { create(:like, user: user, post: delete_like_post) }
    before do
      login_process(user)
      visit root_path
      visit posts_path
    end
    it '投稿詳細画面で投稿にいいねができること' do
      visit post_path(like_post)
      find("#like-button-for-post-#{like_post.id}").click
      expect(page).not_to have_css("#like-button-for-post-#{like_post.id}")
      expect(page).to have_css("#unlike-button-for-post-#{like_post.id}")
      expect(current_path).to eq(post_path(like_post))
    end
    it '投稿詳細画面で投稿につけたいいねを削除できること' do
      visit post_path(delete_like_post)
      find("#unlike-button-for-post-#{like.post.id}").click
      expect(page).not_to have_css("#unlike-button-for-post-#{delete_like_post.id}")
      expect(page).to have_css("#like-button-for-post-#{delete_like_post.id}")
    end
  end
  describe 'いいねした投稿の一覧表示テスト' do
    let!(:user) { create(:user) }
    let!(:another_user) { create(:user) }
    let!(:post1) { create(:post, user: another_user) }
    let!(:post2) { create(:post, user: another_user) }
    let!(:post3) { create(:post, user: another_user) }
    let!(:like1) { create(:like, user: user, post: post1) }
    let!(:like2) { create(:like, user: user, post: post2) }
    let!(:like3) { create(:like, user: user, post: post3) }
    before do
      login_process(user)
      visit root_path
      visit posts_path
    end
    it 'いいねした投稿がいいね一覧に表示されること' do
      visit like_lists_path
      expect(page).to have_content(post1.title)
      expect(page).to have_content(post2.title)
      expect(page).to have_content(post3.title)
      expect(page).to have_content(another_user.name)
    end
    it 'いいね一覧の投稿からいいねを外すといいね一覧から消えていること' do
      visit like_lists_path
      find("#unlike-button-for-post-#{like1.post.id}").click
      find("#unlike-button-for-post-#{like1.post.id}").click
      visit posts_path
      visit like_lists_path
      expect(page).not_to have_content(post1.title)
      expect(page).to have_content(post2.title)
      expect(page).to have_content(post3.title)
    end
  end
end
