require 'rails_helper'

RSpec.describe "Posts", type: :system do
  let(:user) { create(:user) }
  let!(:cat) { create(:cat, user: user) }
  let!(:cat_breed) do
    # 開発環境のデータをコピーしてテスト用データベースに保存
    CatBreed.create!(name: 'マンチカン')
  end
  describe '新規投稿時のテスト' do
    before do
      login_process(user)
      visit root_path
      visit posts_path
    end
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
        expect(page).to have_content('aaaaaa...')
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

  describe '投稿詳細表示のテスト' do
    let!(:user) { create(:user) }
    let!(:another_user) { create(:user) }
    let!(:cat) { create(:cat, user: another_user, cat_breed: cat_breed) }
    let!(:post) { create(:post, user: another_user, cat: cat) }
    let!(:me_post) { create(:post, user: user) }
    before do
      login_process(user)
      visit root_path
      visit posts_path
    end
    it "投稿詳細ページが表示され、投稿者の投稿内容と「X」への共有ボタンが表示されること" do
      visit post_path(post)
      expect(page).to have_content(post.title)
      expect(page).to have_content(post.body)
      expect(page).to have_content(cat.name)
      expect(page).to have_css("#share-button-#{post.id}")
      expect(current_path).to eq(post_path(post))
    end
    it "他人が投稿した投稿の詳細ページが表示され、編集ボタン、削除ボタンが表示されないこと" do
      visit post_path(post)
      expect(page).to have_content(post.title)
      expect(page).to have_content(post.body)
      expect(page).not_to have_css("#button-delete-#{post.id}")
      expect(page).not_to have_css("#button-edit-#{post.id}")
      expect(current_path).to eq(post_path(post))
    end
    it "自分が投稿した投稿の詳細ページが表示され、編集ボタン、削除ボタンが表示されること" do
      visit post_path(me_post)
      expect(page).to have_content(me_post.title)
      expect(page).to have_content(me_post.body)
      expect(page).to have_css("#button-delete-#{me_post.id}")
      expect(page).to have_css("#button-edit-#{me_post.id}")
      expect(current_path).to eq(post_path(me_post))
    end
  end

  describe '投稿一覧表示のテスト' do
    let!(:cat_breed) do
      # 開発環境のデータをコピーしてテスト用データベースに保存
      CatBreed.create!(name: 'マンチカン')
    end
    let(:user) { create(:user) }
    let!(:another_user) { create(:user) }
    let!(:another_user2) { create(:user) }
    let!(:another_user3) { create(:user) }
    let!(:cat) { create(:cat, user: another_user, cat_breed: cat_breed) }
    let!(:cat2) { create(:cat, user: another_user2, cat_breed: cat_breed) }
    let!(:cat3) { create(:cat, user: another_user3, cat_breed: cat_breed) }
    let!(:post) { create(:post, user: another_user, cat: cat) }
    let!(:post2) { create(:post, user: another_user2, cat: cat2) }
    let!(:post3) { create(:post, user: another_user3, cat: cat3) }
    let!(:me_post) { create(:post, user: user) }
    let!(:me_post2) { create(:post, user: user) }
    let!(:me_cat) { create(:cat, user: user, cat_breed: cat_breed) }
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
    it "他人が投稿した投稿が一覧ページで表示され、編集ボタン、削除ボタンが表示されていないこと" do
      # visit post_path(post)
      expect(page).to have_content(post.title)
      expect(page).to have_content(cat.name)
      expect(page).to have_content(post2.title)
      expect(page).to have_content(another_user2.name)
      expect(page).to have_content(cat2.name)
      expect(page).to have_content(post3.title)
      expect(page).to have_content(another_user3.name)
      expect(page).to have_content(cat3.name)
      expect(page).not_to have_css("#button-delete-#{post.id}")
      expect(page).not_to have_css("#button-edit-#{post.id}")
      expect(page).not_to have_css("#button-delete-#{post2.id}")
      expect(page).not_to have_css("#button-edit-#{post3.id}")
      expect(page).not_to have_css("#button-delete-#{post3.id}")
      expect(page).not_to have_css("#button-edit-#{post3.id}")
    end
    it "自分と他人の投稿が一覧ページで表示され、自分の投稿にのみ編集ボタン、削除ボタンが表示されていること" do
      expect(page).to have_content(post.title)
      expect(page).to have_content(cat.name)
      expect(page).to have_content(post2.title)
      expect(page).to have_content(another_user2.name)
      expect(page).to have_content(cat2.name)
      expect(page).to have_content(post3.title)
      expect(page).to have_content(another_user3.name)
      expect(page).to have_content(cat3.name)
      expect(page).to have_content(me_post.title)
      expect(page).to have_content(me_post2.title)
      expect(page).not_to have_css("#button-delete-#{post.id}")
      expect(page).not_to have_css("#button-edit-#{post.id}")
      expect(page).not_to have_css("#button-delete-#{post2.id}")
      expect(page).not_to have_css("#button-edit-#{post3.id}")
      expect(page).not_to have_css("#button-delete-#{post3.id}")
      expect(page).not_to have_css("#button-edit-#{post3.id}")
      expect(page).to have_css("#button-delete-#{me_post.id}")
      expect(page).to have_css("#button-edit-#{me_post.id}")
      expect(page).to have_css("#button-delete-#{me_post2.id}")
      expect(page).to have_css("#button-edit-#{me_post2.id}")
    end
    it "自分の飼っている猫と同じ猫種に関する投稿が一覧ページで表示されていること" do
      visit samebreedcats_posts_path
      expect(page).to have_content(post.title)
      expect(page).to have_content(cat.name)
      expect(page).to have_content(post2.title)
      expect(page).to have_content(another_user2.name)
      expect(page).to have_content(cat2.name)
      expect(page).to have_content(post3.title)
      expect(page).to have_content(another_user3.name)
      expect(page).to have_content(cat3.name)
      expect(page).not_to have_css("#button-delete-#{post.id}")
      expect(page).not_to have_css("#button-edit-#{post.id}")
      expect(page).not_to have_css("#button-delete-#{post2.id}")
      expect(page).not_to have_css("#button-edit-#{post3.id}")
      expect(page).not_to have_css("#button-delete-#{post3.id}")
      expect(page).not_to have_css("#button-edit-#{post3.id}")
    end
  end
  describe '投稿一覧ページからの投稿の編集・更新・削除のテスト' do
    let(:user) { create(:user) }
    let!(:another_user) { create(:user) }
    let!(:another_user2) { create(:user) }
    let!(:another_user3) { create(:user) }
    let!(:cat) { create(:cat, user: another_user, cat_breed: cat_breed) }
    let!(:cat2) { create(:cat, user: another_user2, cat_breed: cat_breed) }
    let!(:cat3) { create(:cat, user: another_user3, cat_breed: cat_breed) }
    let!(:post) { create(:post, user: another_user, cat: cat) }
    let!(:post2) { create(:post, user: another_user2, cat: cat2) }
    let!(:post3) { create(:post, user: another_user3, cat: cat3) }
    let!(:me_cat) { create(:cat, user: user) }
    before do
      login_process(user)
      visit root_path
      visit posts_path
    end
    context '入力に不備がある場合に投稿の更新に失敗し、エラーメッセージが表示されること' do
      it "タイトルがない場合はエラーメッセージが表示されること" do
        expect(page).to have_content(post.title)
        expect(page).to have_content(cat.name)
        expect(page).to have_content(post2.title)
        expect(page).to have_content(another_user2.name)
        expect(page).to have_content(cat2.name)
        expect(page).to have_content(post3.title)
        expect(page).to have_content(another_user3.name)
        expect(page).to have_content(cat3.name)

        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'test-body'
        click_button '投稿'
        expect(page).to have_content('新規投稿が完了しました！')

        edit_post = Post.last
        visit edit_post_path(edit_post)
        expect(current_path).to eq(edit_post_path(edit_post))
        expect(page).to have_content(edit_post.title)
        expect(page).to have_content(edit_post.body)
        fill_in 'post[title]', with: nil
        fill_in 'post[body]', with: 'test-edit-body'
        click_button '投稿'
        expect(page).to have_content('申し訳ありません 投稿の更新に失敗しました')
        expect(page).to have_content('タイトルを入力してください')
        expect(current_path).to eq(edit_post_path(edit_post))
      end
    end
    context '入力に不備がある場合に投稿の更新に失敗し、エラーメッセージが表示されること' do
      it "投稿内容がない場合はエラーメッセージが表示されること" do
        expect(page).to have_content(post.title)
        expect(page).to have_content(cat.name)
        expect(page).to have_content(post2.title)
        expect(page).to have_content(another_user2.name)
        expect(page).to have_content(cat2.name)
        expect(page).to have_content(post3.title)
        expect(page).to have_content(another_user3.name)
        expect(page).to have_content(cat3.name)

        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'test-body'
        click_button '投稿'
        expect(page).to have_content('新規投稿が完了しました！')

        edit_post = Post.last
        visit edit_post_path(edit_post)
        expect(current_path).to eq(edit_post_path(edit_post))
        expect(page).to have_content(edit_post.title)
        expect(page).to have_content(edit_post.body)
        fill_in 'post[title]', with: 'test-edit-body'
        fill_in 'post[body]', with: nil
        click_button '投稿'
        expect(page).to have_content('申し訳ありません 投稿の更新に失敗しました')
        expect(page).to have_content('投稿内容を入力してください')
        expect(current_path).to eq(edit_post_path(edit_post))
      end
    end
    context '入力に不備がある場合に投稿に失敗し、エラーメッセージが表示されること' do
      it "タイトルが21文字以上の場合はエラーメッセージが表示されること" do
        expect(page).to have_content(post.title)
        expect(page).to have_content(cat.name)
        expect(page).to have_content(post2.title)
        expect(page).to have_content(another_user2.name)
        expect(page).to have_content(cat2.name)
        expect(page).to have_content(post3.title)
        expect(page).to have_content(another_user3.name)
        expect(page).to have_content(cat3.name)

        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'test-body'
        click_button '投稿'
        expect(page).to have_content('新規投稿が完了しました！')

        edit_post = Post.last
        visit edit_post_path(edit_post)
        expect(current_path).to eq(edit_post_path(edit_post))
        expect(page).to have_content(edit_post.title)
        expect(page).to have_content(edit_post.body)
        fill_in 'post[title]', with: 'a' * 21
        fill_in 'post[body]', with: 'test-edit-body'
        click_button '投稿'
        expect(page).to have_content('申し訳ありません 投稿の更新に失敗しました')
        expect(page).to have_content('タイトルは20文字以内で入力してください')
        expect(current_path).to eq(edit_post_path(edit_post))
      end
    end
    context '入力に不備がある場合に投稿に失敗し、エラーメッセージが表示されること' do
      it "投稿内容が501文字以上の場合はエラーメッセージが表示されること" do
        expect(page).to have_content(post.title)
        expect(page).to have_content(cat.name)
        expect(page).to have_content(post2.title)
        expect(page).to have_content(another_user2.name)
        expect(page).to have_content(cat2.name)
        expect(page).to have_content(post3.title)
        expect(page).to have_content(another_user3.name)
        expect(page).to have_content(cat3.name)

        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'test-body'
        click_button '投稿'
        expect(page).to have_content('新規投稿が完了しました！')

        edit_post = Post.last
        visit edit_post_path(edit_post)
        expect(current_path).to eq(edit_post_path(edit_post))
        expect(page).to have_content(edit_post.title)
        expect(page).to have_content(edit_post.body)
        fill_in 'post[title]', with: 'test-edit-body'
        fill_in 'post[body]', with: 'a' * 501
        click_button '投稿'
        expect(page).to have_content('申し訳ありません 投稿の更新に失敗しました')
        expect(page).to have_content('投稿内容は500文字以内で入力してください')
        expect(current_path).to eq(edit_post_path(edit_post))
      end
    end
    context '入力内容が正常' do
      it "自分の投稿が一覧ページで表示され、自分の投稿を編集して更新できること" do
        expect(page).to have_content(post.title)
        expect(page).to have_content(cat.name)
        expect(page).to have_content(post2.title)
        expect(page).to have_content(another_user2.name)
        expect(page).to have_content(cat2.name)
        expect(page).to have_content(post3.title)
        expect(page).to have_content(another_user3.name)
        expect(page).to have_content(cat3.name)

        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'test-body'
        click_button '投稿'
        expect(page).to have_content('新規投稿が完了しました！')

        edit_post = Post.last
        visit edit_post_path(edit_post)
        expect(current_path).to eq(edit_post_path(edit_post))
        expect(page).to have_content(edit_post.title)
        expect(page).to have_content(edit_post.body)
        fill_in 'post[title]', with: 'edit'
        fill_in 'post[body]', with: 'test-edit-body'
        click_button '投稿'
        expect(page).to have_content('投稿内容を更新しました！')
        expect(current_path).to eq(posts_path)
        expect(page).not_to have_content(edit_post.title)
        expect(page).to have_content('edit')
      end
    end
    context '入力内容が正常' do
      it "投稿タイトルが20文字以内であり正常に投稿の更新ができること" do
        expect(page).to have_content(post.title)
        expect(page).to have_content(cat.name)
        expect(page).to have_content(post2.title)
        expect(page).to have_content(another_user2.name)
        expect(page).to have_content(cat2.name)
        expect(page).to have_content(post3.title)
        expect(page).to have_content(another_user3.name)
        expect(page).to have_content(cat3.name)

        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'test-body'
        click_button '投稿'
        expect(page).to have_content('新規投稿が完了しました！')

        edit_post = Post.last
        visit edit_post_path(edit_post)
        expect(current_path).to eq(edit_post_path(edit_post))
        expect(page).to have_content(edit_post.title)
        expect(page).to have_content(edit_post.body)
        fill_in 'post[title]', with: 'a' * 20
        fill_in 'post[body]', with: 'test-edit-body'
        click_button '投稿'
        expect(page).to have_content('投稿内容を更新しました！')
        expect(current_path).to eq(posts_path)
        expect(page).not_to have_content(edit_post.title)
        expect(page).to have_content('aaaaaa...')
      end
    end
    context '入力内容が正常' do
      it "投稿内容が500文字以内であり正常に投稿の更新ができること" do
        expect(page).to have_content(post.title)
        expect(page).to have_content(cat.name)
        expect(page).to have_content(post2.title)
        expect(page).to have_content(another_user2.name)
        expect(page).to have_content(cat2.name)
        expect(page).to have_content(post3.title)
        expect(page).to have_content(another_user3.name)
        expect(page).to have_content(cat3.name)

        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'test-body'
        click_button '投稿'
        expect(page).to have_content('新規投稿が完了しました！')

        edit_post = Post.last
        visit edit_post_path(edit_post)
        expect(current_path).to eq(edit_post_path(edit_post))
        expect(page).to have_content(edit_post.title)
        expect(page).to have_content(edit_post.body)
        fill_in 'post[title]', with: 'edit'
        fill_in 'post[body]', with: 'a' * 500
        click_button '投稿'
        expect(page).to have_content('投稿内容を更新しました！')
        expect(current_path).to eq(posts_path)
        expect(page).not_to have_content(edit_post.title)
        expect(page).to have_content('edit')
      end
    end
    context '入力内容が正常' do
      it "投稿に猫の情報を紐づけて、正常に投稿ができること" do
        expect(page).to have_content(post.title)
        expect(page).to have_content(cat.name)
        expect(page).to have_content(post2.title)
        expect(page).to have_content(another_user2.name)
        expect(page).to have_content(cat2.name)
        expect(page).to have_content(post3.title)
        expect(page).to have_content(another_user3.name)
        expect(page).to have_content(cat3.name)

        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'test-body'
        click_button '投稿'
        expect(page).to have_content('新規投稿が完了しました！')

        edit_post = Post.last
        visit edit_post_path(edit_post)
        expect(current_path).to eq(edit_post_path(edit_post))
        expect(page).to have_content(edit_post.title)
        expect(page).to have_content(edit_post.body)
        fill_in 'post[title]', with: 'edit'
        fill_in 'post[body]', with: 'test-edit-body'
        select me_cat.name, from: 'post[cat_id]'
        click_button '投稿'
        expect(page).to have_content('投稿内容を更新しました！')
        expect(current_path).to eq(posts_path)
        expect(page).not_to have_content(edit_post.title)
        expect(page).to have_content('edit')
        expect(page).to have_content(me_cat.name)
      end
    end
  end
end
