require 'rails_helper'

RSpec.describe 'Searches', type: :system do
  describe '検索機能のオートコンプリート機能の表示テスト' do
    let!(:another_user) { create(:user) }
    let!(:another_user2) { create(:user, name: 'search-user') }
    let!(:cat) { create(:cat, name: 'search-cat', user: another_user) }
    let!(:post1) { create(:post, user: another_user, title: 'search-title-first') }
    let!(:post2) { create(:post, user: another_user, title: 'search-title-second') }
    let!(:post3) { create(:post, user: another_user, title: 'search-title-third') }
    let!(:post4) { create(:post, user: another_user, title: 'search-title-4', body: 'search-body') }
    let!(:post5) { create(:post, user: another_user, cat: cat, title: 'cat') }
    let!(:post6) { create(:post, user: another_user2, title: 'user') }
    let!(:post7) { create(:post, user: another_user, title: 'postA') }
    let!(:post8) { create(:post, user: another_user, title: 'postB') }
    let!(:post9) { create(:post, user: another_user, title: 'postC') }
    let!(:posts) { create_list(:post, 12) }
    before do
      visit root_path
      visit posts_path
    end
    context '投稿一覧画面での検索' do
      it '投稿のタイトルを入力してオートコンプリート機能が動作して存在する投稿の「タイトル」が表示されること' do
        fill_in 'q_title_or_body_or_user_name_or_cat_name_cont', with: 'search'
        expect(page).to have_content('タイトル一覧')
        expect(page).to have_content('search-title-first')
        expect(page).to have_content('search-title-second')
        expect(page).to have_content('search-title-third')
      end
      it '投稿のタイトルを入力してオートコンプリート機能が動作して存在する投稿の「タイトル」をクリックしたら検索欄に入力された状態となること' do
        fill_in 'q_title_or_body_or_user_name_or_cat_name_cont', with: 'search'
        expect(page).to have_content('タイトル一覧')
        expect(page).to have_content('search-title-first')
        expect(page).to have_content('search-title-second')
        expect(page).to have_content('search-title-third')
        find("li[data-autocomplete-value='#{post1.id}']").click
        expect(page).to have_field('q[title_or_body_or_user_name_or_cat_name_cont]', with: 'search-title-first')
      end
      it '投稿内容を入力してオートコンプリート機能が動作して存在する投稿内容の「タイトル」をクリックしたら検索欄に入力された状態となること' do
        fill_in 'q_title_or_body_or_user_name_or_cat_name_cont', with: 'search'
        expect(page).to have_content('タイトル一覧')
        expect(page).to have_content('search-title-first')
        expect(page).to have_content('search-title-second')
        expect(page).to have_content('search-title-third')
        expect(page).to have_content(post4.title)
        find("li[data-autocomplete-value='#{post4.id}']").click
        expect(page).to have_field('q[title_or_body_or_user_name_or_cat_name_cont]', with: post4.title)
      end
      it '猫の名前を入力してオートコンプリート機能が動作して検索欄に入力した「猫」の投稿に紐づけられた「タイトル」をクリックしたら検索欄に入力された状態となること' do
        fill_in 'q_title_or_body_or_user_name_or_cat_name_cont', with: 'search'
        expect(page).to have_content('タイトル一覧')
        expect(page).to have_content('search-title-first')
        expect(page).to have_content('search-title-second')
        expect(page).to have_content('search-title-third')
        expect(page).to have_content(post5.title)
        find("li[data-autocomplete-value='#{post5.id}']").click
        expect(page).to have_field('q[title_or_body_or_user_name_or_cat_name_cont]', with: post5.title)
      end
      it 'ユーザーの名前を入力して、オートコンプリート機能が動作して検索欄に入力した「ユーザー」の投稿に紐づけられた「タイトル」をクリックしたら検索欄に入力された状態となること' do
        fill_in 'q_title_or_body_or_user_name_or_cat_name_cont', with: 'search'
        expect(page).to have_content('タイトル一覧')
        expect(page).to have_content('search-title-first')
        expect(page).to have_content('search-title-second')
        expect(page).to have_content('search-title-third')
        expect(page).to have_content(post6.title)
        find("li[data-autocomplete-value='#{post6.id}']").click
        expect(page).to have_field('q[title_or_body_or_user_name_or_cat_name_cont]', with: post6.title)
      end
      it '検索ボタンを押すと該当する投稿のみ表示されること' do
        fill_in 'q_title_or_body_or_user_name_or_cat_name_cont', with: 'post'
        expect(page).to have_content('タイトル一覧')
        expect(page).to have_content(post7.title)
        expect(page).to have_content(post8.title)
        expect(page).to have_content(post9.title)
        find("li[data-autocomplete-value='#{post7.id}']").click
        expect(page).to have_field('q[title_or_body_or_user_name_or_cat_name_cont]', with: post7.title)
        click_button '検索'
        expect(current_path).to eq(posts_path)
        expect(page).to have_content(post7.title)
        expect(page).not_to have_content(post8.title)
        expect(page).not_to have_content(post9.title)
      end
    end
  end
end
