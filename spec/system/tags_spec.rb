require 'rails_helper'

RSpec.describe "Tags", type: :system do
  let(:user) { create(:user) }
  let!(:cat_breed) do
    # 開発環境のデータをコピーしてテスト用データベースに保存
    CatBreed.create!(name: 'マンチカン')
  end
  let(:cat) { create(:cat) }
  
  describe 'タグのテスト' do
    before do
      login_process(user)
      visit root_path
    end
    context '入力内容が正常' do
      it "タグが保存されること" do
        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'test-body'
        fill_in 'post[name]', with: 'test-tag'
        click_button '投稿'
        expect(page).to have_content('test-tag')
        expect(current_path).to eq(posts_path)
      end
    end
    context '入力内容が正常' do
      it "タグが複数保存されること" do
        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'test-body'
        fill_in 'post[name]', with: 'test-tag,test-tag2,test-tag3'
        click_button '投稿'
        expect(page).to have_content('test-tag')
        expect(page).to have_content('test-tag2')
        expect(page).to have_content('test-tag3')
        expect(current_path).to eq(posts_path)
      end
    end
    context '入力内容が正常' do
      it "同じタグが重複して保存されないこと" do
        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'test-body'
        fill_in 'post[name]', with: 'test-tag'
        click_button '投稿'
        expect(page).to have_content('新規投稿が完了しました！')
        expect(current_path).to eq(posts_path)

        visit new_post_path
        fill_in 'post[title]', with: 'test-title2'
        fill_in 'post[body]', with: 'test-body2'
        fill_in 'post[name]', with: 'test-tag'
        expect { click_button '投稿' }.not_to change { Tag.count }
        expect(page).to have_content('新規投稿が完了しました！')
        expect(current_path).to eq(posts_path)
      end
    end
  end
  describe 'タグの編集テスト' do
    before do
      login_process(user)
      visit root_path
    end
    context '入力内容が正常' do
      it "タグが編集できること" do
        visit new_post_path
        fill_in 'post[title]', with: 'test-title-tag'
        fill_in 'post[body]', with: 'test-body'
        fill_in 'post[name]', with: 'test-tag,test-tag2,test-tag3'
        click_button '投稿'
        expect(page).to have_content('新規投稿が完了しました！')
        expect(page).to have_content('test-tag')
        expect(page).to have_content('test-tag2')
        expect(page).to have_content('test-tag3')
        expect(current_path).to eq(posts_path)

        post = Post.last
        visit edit_post_path(post)
        expect(page).to have_selector("input[value='test-tag,test-tag2,test-tag3']")
        fill_in 'post[name]', with: 'test-tag,test-tag-edit,test-tag-edit2'
        click_button '投稿'
        expect(page).to have_content('投稿内容を更新しました！')
        expect(page).to have_content('test-tag')
        expect(page).to have_content('test-tag-edit')
        expect(page).to have_content('test-tag-edit2')
        expect(page).not_to have_content('test-tag2')
        expect(page).not_to have_content('test-tag3')
        expect(current_path).to eq(posts_path)
      end
    end
  end
end
