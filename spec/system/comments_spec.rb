require 'rails_helper'

RSpec.describe "Comments", type: :system do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:post) { create(:post, user: another_user) }
  let(:cat) { create(:cat) }
  let!(:cat_breed) do
    # 開発環境のデータをコピーしてテスト用データベースに保存
    CatBreed.create!(name: 'マンチカン')
  end
  describe 'コメント投稿のテスト' do
    before do
      login_process(user)
      visit root_path
      visit posts_path
    end
    context '入力に不備がある場合にコメント投稿に失敗し、エラーメッセージが表示されること' do
      it "内容がない場合はエラーメッセージが表示されること" do
        visit post_path(post)
        fill_in 'comment[body]', with: nil
        click_button 'コメント投稿'
        expect(page).to have_content('コメントを入力してください')
        expect(current_path).to eq(post_path(post))
      end
    end
    context '入力に不備がある場合にコメント投稿に失敗し、エラーメッセージが表示されること' do
      it "コメントが501文字以上の場合はエラーメッセージが表示されること" do
        visit post_path(post)
        fill_in 'comment[body]', with: 'a' * 501
        click_button 'コメント投稿'
        expect(page).to have_content('コメントは500文字以内で入力してください')
        expect(current_path).to eq(post_path(post))
      end
    end
    context '入力内容が正常' do
      it "正常にコメント投稿ができること" do
        visit post_path(post)
        fill_in 'comment[body]', with: 'test-comment'
        click_button 'コメント投稿'
        expect(page).to have_content('test-comment')
        expect(page).not_to have_content('コメントを入力してください')
        expect(page).not_to have_content('コメントは500文字以内で入力してください')
        expect(current_path).to eq(post_path(post))
      end
    end
    context '入力内容が正常' do
      it "コメント内容が500文字以内であり正常にコメント投稿ができること" do
        visit post_path(post)
        fill_in 'comment[body]', with: 'a' * 500
        click_button 'コメント投稿'
        expect(page).to have_content('a' * 500)
        expect(page).not_to have_content('コメントを入力してください')
        expect(page).not_to have_content('コメントは500文字以内で入力してください')
        expect(current_path).to eq(post_path(post))
      end
    end
  end
  describe 'コメント一覧の表示テスト' do
    let!(:comment_user) { create(:user) }
    let!(:comment_user2) { create(:user) }
    let!(:comment_user3) { create(:user) }
    let!(:comment_post) { create(:post, user: another_user) }
    let!(:comment1) { create(:comment, user: comment_user, post: comment_post) }
    let!(:comment2) { create(:comment, user: comment_user2, post: comment_post) }
    let!(:comment3) { create(:comment, user: comment_user3, post: comment_post) }
    before do
      login_process(user)
      visit root_path
      visit posts_path
    end
    it "コメント一覧が表示されること" do
      visit post_path(comment_post)
      expect(current_path).to eq(post_path(comment_post))
      expect(page).to have_content(comment1.body)
      expect(page).to have_content(comment2.body)
      expect(page).to have_content(comment3.body)
      expect(page).to have_content(comment1.user.name)
      expect(page).to have_content(comment2.user.name)
      expect(page).to have_content(comment3.user.name)
    end
  end
  describe 'コメントの削除のテスト' do
    let!(:destroy_comment) { create(:comment, user: user, post: post) }
    before do
      login_process(user)
      visit root_path
      visit posts_path
    end
    it "自分のコメントが削除されること" do
      visit post_path(post)
      expect(page).to have_content(destroy_comment.body)
      accept_alert do
        find("a[href='#{comment_path(destroy_comment)}'][data-turbo-method='delete']").click
      end
      expect(page).not_to have_content(destroy_comment.body)
    end
  end
end
