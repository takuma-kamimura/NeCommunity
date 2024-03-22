require 'rails_helper'

RSpec.describe 'Tags', type: :system do
  let(:user) { create(:user) }
  # let!(:cat_breed) do
  #   # 開発環境のデータをコピーしてテスト用データベースに保存
  #   CatBreed.create!(name: 'マンチカン')
  # end
  let(:cat) { create(:cat) }
  
  describe 'タグの生成テスト' do
    before do
      login_process(user)
      visit root_path
    end
    context '入力内容が正常' do
      it 'タグが保存されること' do
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
      it 'タグが複数保存されること' do
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
      it '同じタグが重複して保存されないこと' do
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
    context '入力内容が正常' do
      it '一つの投稿に対してタグが4つ以上設定されないこと' do
        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'test-body'
        fill_in 'post[name]', with: 'test-tag,test-tag2,test-tag3,test-tag4'
        click_button '投稿'
        expect(page).to have_content('申し訳ありません タグは3つまででお願いします')
        expect(current_path).to eq(new_post_path)
      end
    end
  end
  describe 'タグの編集テスト' do
    before do
      login_process(user)
      visit root_path
    end
    context '入力に不備がある場合に更新に失敗し、エラーメッセージが表示されること' do
      it 'タグが編集時、一つの投稿に対してタグが4つ以上設定されないこと' do
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
        fill_in 'post[name]', with: 'test-tag,test-tag-edit,test-tag-edit2,test-tag-edit3,test-tag-edit4'
        click_button '投稿'
        expect(page).to have_content('申し訳ありません タグは3つまででお願いします')
        expect(current_path).to eq(edit_post_path(post))
      end
    end
    context '入力内容が正常' do
      it 'タグが編集できること' do
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
  describe 'タグの絞り込み検索テスト' do
    let!(:post1) { create(:post) }
    let!(:post2) { create(:post) }
    let!(:post3) { create(:post) }
    let!(:tag1) { create(:tag) }
    let!(:tag2) { create(:tag) }
    before do
      post1.tags << tag1
      post2.tags << tag1
      post3.tags << tag2
    end
    context 'タグで検索できるか' do
      it '投稿にタグが付与されている場合、同じ「タグ名」がついた投稿のみ投稿一覧に表示できるか' do
        visit posts_path
        expect(page).to have_content(post1.title)
        expect(page).to have_content(post2.title)
        expect(page).to have_content(post3.title)
        first(:link, tag1.name).click
        first(:link, tag1.name).click
        expect(current_path).to eq(posts_path)
        expect(page).to have_content(post1.title)
        expect(page).to have_content(post2.title)
        expect(page).not_to have_content(post3.title)
      end
    end
  end
end
