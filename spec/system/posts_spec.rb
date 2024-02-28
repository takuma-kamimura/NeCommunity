require 'rails_helper'

RSpec.describe "Posts", type: :system do
  let(:user) { create(:user) }
  let!(:cat) { create(:cat, user: user) }
  let!(:cat_breed) do
    # 開発環境のデータをコピーしてテスト用データベースに保存
    CatBreed.create!(name: 'マンチカン')
  end
  before do
    login_process(user)
    visit root_path
    visit posts_path
  end
  describe '新規投稿時のテスト' do
    context '入力に不備がある場合に投稿に失敗し、エラーメッセージが表示されること' do
      it "タイトルがない場合はエラーメッセージが表示されること" do
        visit new_post_path
        fill_in 'post[title]', with: nil
        fill_in 'post[body]', with: 'test-body'
        click_button '投稿'
        expect(page).to have_content('申し訳ありません 新規投稿に失敗しました')
        expect(page).to have_content('タイトルを入力してください')
        expect(current_path).to eq(new_post_path)
      end
    end
    context '入力に不備がある場合に投稿に失敗し、エラーメッセージが表示されること' do
      it "投稿内容がない場合はエラーメッセージが表示されること" do
        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: nil
        click_button '投稿'
        expect(page).to have_content('申し訳ありません 新規投稿に失敗しました')
        expect(page).to have_content('投稿内容を入力してください')
        expect(current_path).to eq(new_post_path)
      end
    end
    context '入力に不備がある場合に投稿に失敗し、エラーメッセージが表示されること' do
      it "タイトルが21文字以上の場合はエラーメッセージが表示されること" do
        visit new_post_path
        fill_in 'post[title]', with: 'a' * 21
        fill_in 'post[body]', with: 'test-body'
        click_button '投稿'
        expect(page).to have_content('申し訳ありません 新規投稿に失敗しました')
        expect(page).to have_content('タイトルは20文字以内で入力してください')
        expect(current_path).to eq(new_post_path)
      end
    end
    context '入力に不備がある場合に投稿に失敗し、エラーメッセージが表示されること' do
      it "投稿内容が501文字以上の場合はエラーメッセージが表示されること" do
        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'a' * 501
        click_button '投稿'
        expect(page).to have_content('申し訳ありません 新規投稿に失敗しました')
        expect(page).to have_content('投稿内容は500文字以内で入力してください')
        expect(current_path).to eq(new_post_path)
      end
    end
    context '入力内容が正常' do
      it "正常に投稿ができること" do
        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'test-body'
        click_button '投稿'
        expect(page).to have_content('新規投稿が完了しました！')
        expect(current_path).to eq(posts_path)
      end
    end
    context '入力内容が正常' do
      it "投稿タイトルが20文字以内であり正常に投稿ができること" do
        visit new_post_path
        fill_in 'post[title]', with: 'a' * 20
        fill_in 'post[body]', with: 'test-body'
        click_button '投稿'
        expect(page).to have_content('新規投稿が完了しました！')
        expect(current_path).to eq(posts_path)
      end
    end
    context '入力内容が正常' do
      it "投稿内容が500文字以内であり正常に投稿ができること" do
        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'a' * 500
        click_button '投稿'
        expect(page).to have_content('新規投稿が完了しました！')
        expect(current_path).to eq(posts_path)
      end
    end
    context '入力内容が正常' do
      it "投稿に猫の情報を紐づけて、正常に投稿ができること" do
        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'test-body'
        select cat.name, from: 'post[cat_id]'
        click_button '投稿'
        expect(page).to have_content('新規投稿が完了しました！')
        expect(current_path).to eq(posts_path)
        expect(page).to have_content(cat.name)
      end
    end
  end
  describe '投稿一覧表示のテスト' do
    let!(:cat_breed) do
      # 開発環境のデータをコピーしてテスト用データベースに保存
      CatBreed.create!(name: 'マンチカン')
    end
    let!(:another_user) { create(:user) }
    let!(:another_user2) { create(:user) }
    let!(:another_user3) { create(:user) }
    let!(:cat) { create(:cat, user: another_user, cat_breed: cat_breed) }
    let!(:cat2) { create(:cat, user: another_user2, cat_breed: cat_breed) }
    let!(:cat3) { create(:cat, user: another_user3, cat_breed: cat_breed) }

    let!(:post) { create(:post, user: another_user, cat: cat) }
    let!(:post2) { create(:post, user: another_user2, cat: cat2) }
    let!(:post3) { create(:post, user: another_user3, cat: cat3) }

    before do
      login_process(user)
      visit root_path
      visit posts_path
    end
    it "投稿一覧が表示されること" do
      expect(page).to have_content(post.title)
      expect(page).to have_content(another_user.name)
      expect(page).to have_content(cat.name)
      expect(page).to have_content(post2.title)
      expect(page).to have_content(another_user2.name)
      expect(page).to have_content(cat2.name)
      expect(page).to have_content(post3.title)
      expect(page).to have_content(another_user3.name)
      expect(page).to have_content(cat3.name)
    end
  end
end
