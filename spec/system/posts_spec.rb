require 'rails_helper'

RSpec.describe "Posts", type: :system do
  let(:user) { create(:user) }
  let(:cat) { create(:cat) }
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
  end
end
