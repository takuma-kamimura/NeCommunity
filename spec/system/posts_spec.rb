require 'rails_helper'

RSpec.describe 'Posts', type: :system do
  let(:user) { create(:user) }
  let!(:cat) { create(:cat, user: user) }
  let!(:cat_breed) do
    # 開発環境のデータをコピーしてテスト用データベースに保存
    CatBreed.create!(name: 'マンチカン')
  end
  describe 'ログイン・ログアウト状態の投稿一覧の表示テスト' do
    let!(:another_user) { create(:user) }
    let!(:post) { create(:post, user: another_user) }
    before do
      visit root_path
      visit posts_path
    end
    context 'ログアウト状態の場合' do
      it '「新規投稿」ボタンが表示されないこと' do
        expect(page).not_to have_link '新規投稿', href: new_post_path
      end
    end
    context 'ログアウト状態の場合' do
      it '「いいね一覧」ボタンが表示されないこと' do
        expect(page).not_to have_link 'いいね一覧', href: like_lists_path
      end
    end
    context 'ログアウト状態の場合' do
      it '「貴方の猫\'sと同猫種」ボタンが表示されないこと' do
        expect(page).not_to have_link '貴方の猫\'sと同猫種', href: samebreedcats_path
      end
    end
    context 'ログイン状態の場合' do
      it '「新規投稿」ボタンが表示されること' do
        login_process(user)
        visit root_path
        visit posts_path
        expect(page).to have_link '新規投稿', href: new_post_path
      end
    end
    context 'ログイン状態の場合' do
      it '「いいね一覧」ボタンが表示されること' do
        login_process(user)
        visit root_path
        visit posts_path
        expect(page).to have_link 'いいね一覧', href: like_lists_path
      end
    end
    context 'ログイン状態の場合' do
      it '「貴方の猫\'sと同猫種」ボタンが表示されること' do
        login_process(user)
        visit root_path
        visit posts_path
        expect(page).to have_link '貴方の猫\'sと同猫種', href: samebreedcats_path
      end
    end
  end
  describe '新規投稿時のテスト' do
    before do
      login_process(user)
      visit root_path
      visit posts_path
    end
    context '入力に不備がある場合に投稿に失敗し、エラーメッセージが表示されること' do
      it 'タイトルがない場合はエラーメッセージが表示されること' do
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
      it '投稿内容がない場合はエラーメッセージが表示されること' do
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
      it 'タイトルが21文字以上の場合はエラーメッセージが表示されること' do
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
      it '投稿内容が501文字以上の場合はエラーメッセージが表示されること' do
        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'a' * 501
        click_button '投稿'
        expect(page).to have_content('申し訳ありません 新規投稿に失敗しました')
        expect(page).to have_content('投稿内容は500文字以内で入力してください')
        expect(current_path).to eq(new_post_path)
      end
    end
    context '入力に不備がある場合に投稿に失敗し、エラーメッセージが表示されること' do
      it '猫以外の画像を添付して、投稿ボタンを押すとエラーメッセージが表示されること' do
        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'test-body'
        select cat.name, from: 'post[cat_id]'
        image_path = Rails.root.join('spec/images/ゴリラ.jpeg')
        attach_file 'avatar-file', image_path
        click_button '投稿'
        sleep 5
        expect(page).to have_content('猫ちゃんに関係ない画像は投稿しないでください！')
        expect(current_path).to eq(new_post_path)
      end
    end
    context '入力内容が正常' do
      it '正常に投稿ができること。画像を添付していない場合はデフォルト画像が設定されていること' do
        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'test-body'
        click_button '投稿'
        expect(page).to have_content('新規投稿が完了しました！')
        expect(current_path).to eq(posts_path)
        selector = "img[src*='post_default'][src*='.webp']"
        expect(page).to have_selector(selector)
      end
    end
    context '入力内容が正常' do
      it '投稿タイトルが20文字以内であり正常に投稿ができること' do
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
      it '投稿内容が500文字以内であり正常に投稿ができること' do
        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'a' * 500
        click_button '投稿'
        expect(page).to have_content('新規投稿が完了しました！')
        expect(current_path).to eq(posts_path)
      end
    end
    context '入力内容が正常' do
      it '投稿に猫の情報を紐づけて、正常に投稿ができること' do
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
    context '入力内容が正常' do
      it '猫の画像を添付して、正常に投稿ができること' do
        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'test-body'
        select cat.name, from: 'post[cat_id]'
        image_path = Rails.root.join('spec/images/test-cat-photo.webp')
        attach_file 'avatar-file', image_path
        click_button '投稿'
        sleep 5
        expect(page).to have_content('新規投稿が完了しました！')
        expect(current_path).to eq(posts_path)
        expect(page).to have_content(cat.name)
        expect(page).to have_selector("img[src$='test-cat-photo.webp']")
      end
    end
  end

  describe '投稿詳細表示のテスト' do
    let!(:user) { create(:user) }
    let!(:another_user) { create(:user) }
    let!(:cat) { create(:cat, user: another_user, cat_breed: cat_breed) }
    let!(:me_cat) { create(:cat, user: user, cat_breed: cat_breed) }
    let!(:post) { create(:post, user: another_user, cat: cat) }
    let!(:me_post) { create(:post, user: user) }
    let!(:me_cat_post) { create(:post, user: user, cat: me_cat) }
    before do
      login_process(user)
      visit root_path
      visit posts_path
    end
    it '投稿詳細ページが表示され、投稿者の投稿内容と「X」への共有ボタンが表示されること' do
      visit post_path(post)
      expect(page).to have_content(post.title)
      expect(page).to have_content(post.body)
      expect(page).to have_content(cat.name)
      expect(page).to have_css("#share-button-#{post.id}")
      expect(current_path).to eq(post_path(post))
    end
    it '他人が投稿した投稿の詳細ページが表示され、編集ボタン、削除ボタンが表示されないこと' do
      visit post_path(post)
      expect(page).to have_content(post.title)
      expect(page).to have_content(post.body)
      expect(page).not_to have_css("#button-delete-#{post.id}")
      expect(page).not_to have_css("#button-edit-#{post.id}")
      expect(current_path).to eq(post_path(post))
    end
    it '自分が投稿した投稿の詳細ページが表示され、編集ボタン、削除ボタンが表示されること' do
      visit post_path(me_post)
      expect(page).to have_content(me_post.title)
      expect(page).to have_content(me_post.body)
      expect(page).to have_css("#button-delete-#{me_post.id}")
      expect(page).to have_css("#button-edit-#{me_post.id}")
      expect(current_path).to eq(post_path(me_post))
    end
    it '他人が投稿した投稿の詳細ページが表示され、投稿者のモーダルウィンドウが表示され投稿者のマイ猫sのリンクがあり、リンク先で投稿者の猫一覧が確認できること。' do
      visit post_path(post)
      expect(page).to have_content(post.title)
      expect(page).to have_content(post.body)
      expect(page).to have_link(another_user.name)


      click_button another_user.name
      expect(page).to have_content('飼い主さんのお名前')
      expect(current_path).to eq(post_path(post))
      click_link "#{another_user.name}さんのマイ猫\'s"
      sleep 2
      expect(current_path).to eq(usercat_users_path)
      expect(page).to have_content("#{another_user.name}さんのマイ猫\'s")
      expect(page).to have_content(cat.name)
    end
    it '投稿の詳細ページで猫のモーダルウィンドウが表示され、猫の名前のリンクを押すとその猫の投稿一覧が表示される' do
      visit post_path(post)
      expect(page).to have_content(post.title)
      expect(page).to have_content(post.body)
      find("#cat-avatar-for-post-show-#{cat.id}").click
      expect(page).to have_content(cat.name)
      expect(page).to have_content('ネコの名前')
      expect(page).not_to have_css("#cat-edit-#{cat.id }")
      expect(page).not_to have_css("#cat-delete-#{cat.id}")
      expect(current_path).to eq(post_path(post))
      expect(page).to have_link("#{cat.decorate.cat_name}の投稿一覧")
      click_link "#{cat.decorate.cat_name}の投稿一覧"
      expect(page).to have_content("#{cat.decorate.cat_name}の投稿一覧")
      expect(page).to have_content(post.title)
      expect(page).to have_content(post.title)
      expect(page).to have_content(another_user.name)
    end
    it '他人が投稿した投稿の詳細ページで猫のモーダルウィンドウが表示され、編集ボタン、削除ボタンが表示されないこと' do
      visit post_path(post)
      expect(page).to have_content(post.title)
      expect(page).to have_content(post.body)
      find("#cat-avatar-for-post-show-#{cat.id}").click
      expect(page).to have_content(cat.name)
      expect(page).to have_content('ネコの名前')
      expect(page).not_to have_css("#cat-edit-#{cat.id }")
      expect(page).not_to have_css("#cat-delete-#{cat.id}")
      expect(current_path).to eq(post_path(post))
    end
    it '自分が投稿した投稿の詳細ページで猫のモーダルウィンドウが表示され、編集ボタン、削除ボタンが表示されること' do
      visit post_path(me_cat_post)
      expect(page).to have_content(me_cat_post.title)
      expect(page).to have_content(me_cat_post.body)
      find("#cat-avatar-for-post-show-#{me_cat.id}").click
      expect(page).to have_content(me_cat.name)
      expect(page).to have_content('ネコの名前')
      expect(page).to have_css("#cat-edit-#{me_cat.id }")
      expect(page).to have_css("#cat-delete-#{me_cat.id}")
      expect(current_path).to eq(post_path(me_cat_post))
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
    it '投稿一覧が表示されること' do
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
    it '他人が投稿した投稿が一覧ページで表示され、編集ボタン、削除ボタンが表示されていないこと' do
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
    it '自分と他人の投稿が一覧ページで表示され、自分の投稿にのみ編集ボタン、削除ボタンが表示されていること' do
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
    it '自分の飼っている猫と同じ猫種に関する投稿が一覧ページで表示されていること' do
      visit samebreedcats_path
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
      it 'タイトルがない場合はエラーメッセージが表示されること' do
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
      it '投稿内容がない場合はエラーメッセージが表示されること' do
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
    context '入力に不備がある場合に投稿の更新に失敗し、エラーメッセージが表示されること' do
      it 'タイトルが21文字以上の場合はエラーメッセージが表示されること' do
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
    context '入力に不備がある場合に投稿の更新に失敗し、エラーメッセージが表示されること' do
      it '投稿内容が501文字以上の場合はエラーメッセージが表示されること' do
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
    context '入力に不備がある場合に投稿の更新に失敗し、エラーメッセージが表示されること' do
      it '猫以外の画像を添付して、投稿ボタンを押すとエラーメッセージが表示されること' do

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
        fill_in 'post[title]', with: 'test-edit-totle'
        fill_in 'post[body]', with: 'test-edit-body'
        image_path = Rails.root.join('spec/images/ゴリラ.jpeg')
        attach_file 'avatar-file', image_path
        click_button '投稿'
        sleep 5
        expect(page).to have_content('猫ちゃんに関係ない画像は投稿しないでください！')
        expect(current_path).to eq(edit_post_path(edit_post))
      end
    end
    context '入力内容が正常' do
      it '自分の投稿が一覧ページで表示され、自分の投稿を編集して更新できること' do
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
      it '投稿タイトルが20文字以内であり正常に投稿の更新ができること' do
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
      it '投稿内容が500文字以内であり正常に投稿の更新ができること' do
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
      it '投稿に猫の情報を紐づけて、正常に投稿ができること' do
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
    context '入力内容が正常' do
      it '投稿に猫の画像を添付して、正常に投稿ができること' do
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
        image_path = Rails.root.join('spec/images/test-cat-photo.webp')
        attach_file 'avatar-file', image_path
        click_button '投稿'
        sleep 10
        expect(page).to have_content('投稿内容を更新しました！')
        expect(current_path).to eq(posts_path)
        expect(page).not_to have_content(edit_post.title)
        expect(page).to have_content('edit')
        expect(page).to have_content(me_cat.name)
        expect(page).to have_selector("img[src$='test-cat-photo.webp']")
      end
    end
    context '投稿の削除の処理が正常' do
      it '自分の投稿が投稿一覧ページで削除できること' do
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
        destroy_post = Post.last
        visit posts_path
        find("a[href='/posts/#{destroy_post.id}'][data-turbo-method='delete']").click
        accept_alert do
          find("a[href='/posts/#{destroy_post.id}'][data-turbo-method='delete']").click
        end
        expect(page).to have_content('投稿を削除しました！')
        expect(page).not_to have_content(destroy_post.title)
      end
    end
  end
  describe 'ページネーションのテスト' do
    let!(:cat_breed) do
      # 開発環境のデータをコピーしてテスト用データベースに保存
      CatBreed.create!(name: 'マンチカン')
    end
    let(:user) { create(:user) }
    before do
      login_process(user)
      visit root_path
      visit posts_path
    end
    context '投稿一覧が12件以内の場合' do
      let!(:posts) { create_list(:post, 12) }
      it 'ページネーションが表示されないこと' do
        login_process(user)
        visit posts_path
        expect(page).not_to have_selector('.pagination')
      end
    end
    context '投稿一覧が13件以上の場合' do
      let!(:posts) { create_list(:post, 13) }
      it 'ページネーションが表示されること' do
        login_process(user)
        visit posts_path
        expect(page).to have_selector('.pagination')
      end
    end
  end
  describe '投稿詳細ページからの投稿の編集・更新・削除のテスト' do
    let!(:user) { create(:user) }
    let!(:me_cat) { create(:cat, user: user) }
    before do
      login_process(user)
      visit root_path
      visit posts_path
    end
    context '入力に不備がある場合に投稿の更新に失敗し、エラーメッセージが表示されること' do
      it 'タイトルがない場合はエラーメッセージが表示されること' do
        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'test-body'
        click_button '投稿'
        expect(page).to have_content('新規投稿が完了しました！')

        edit_post = Post.last
        visit edit_post_path(edit_post)
        fill_in 'post[title]', with: nil
        fill_in 'post[body]', with: 'test-body'
        click_button '投稿'
        expect(page).to have_content('申し訳ありません 投稿の更新に失敗しました')
        expect(page).to have_content('タイトルを入力してください')
        expect(current_path).to eq(edit_post_path(edit_post))
      end
    end
    context '入力に不備がある場合に投稿の更新に失敗し、エラーメッセージが表示されること' do
      it '投稿内容がない場合はエラーメッセージが表示されること' do
        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'test-body'
        click_button '投稿'
        expect(page).to have_content('新規投稿が完了しました！')

        edit_post = Post.last
        visit edit_post_path(edit_post)
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: nil
        click_button '投稿'
        expect(page).to have_content('申し訳ありません 投稿の更新に失敗しました')
        expect(page).to have_content('投稿内容を入力してください')
        expect(current_path).to eq(edit_post_path(edit_post))
      end
    end
    context '入力に不備がある場合に投稿の更新に失敗し、エラーメッセージが表示されること' do
      it 'タイトルが21文字以上の場合はエラーメッセージが表示されること' do
        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'test-body'
        click_button '投稿'
        expect(page).to have_content('新規投稿が完了しました！')

        edit_post = Post.last
        visit edit_post_path(edit_post)
        fill_in 'post[title]', with: 'a' * 21
        fill_in 'post[body]', with: 'test-body'
        click_button '投稿'
        expect(page).to have_content('申し訳ありません 投稿の更新に失敗しました')
        expect(page).to have_content('タイトルは20文字以内で入力してください')
        expect(current_path).to eq(edit_post_path(edit_post))
      end
    end
    context '入力に不備がある場合に投稿の更新に失敗し、エラーメッセージが表示されること' do
      it '投稿内容が501文字以上の場合はエラーメッセージが表示されること' do
        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'test-body'
        click_button '投稿'
        expect(page).to have_content('新規投稿が完了しました！')

        edit_post = Post.last
        visit edit_post_path(edit_post)
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'a' * 501
        click_button '投稿'
        expect(page).to have_content('申し訳ありません 投稿の更新に失敗しました')
        expect(page).to have_content('投稿内容は500文字以内で入力してください')
        expect(current_path).to eq(edit_post_path(edit_post))
      end
    end
    context '入力に不備がある場合に投稿の更新に失敗し、エラーメッセージが表示されること' do
      it '猫以外の画像を添付して、投稿ボタンを押すとエラーメッセージが表示されること' do
        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'test-body'
        click_button '投稿'
        expect(page).to have_content('新規投稿が完了しました！')

        edit_post = Post.last
        visit edit_post_path(edit_post)
        fill_in 'post[title]', with: 'test-edit-title'
        fill_in 'post[body]', with: 'test-edit-body'
        image_path = Rails.root.join('spec/images/ゴリラ.jpeg')
        attach_file 'avatar-file', image_path
        click_button '投稿'
        sleep 5
        expect(page).to have_content('猫ちゃんに関係ない画像は投稿しないでください！')
        expect(current_path).to eq(edit_post_path(edit_post))
      end
    end
    context '入力内容が正常' do
      it '自分の投稿が投稿詳細画面で表示され、自分の投稿を編集して更新できること' do
        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'test-body'
        click_button '投稿'
        expect(page).to have_content('新規投稿が完了しました！')

        edit_post = Post.last
        visit post_path(edit_post)
        visit edit_post_path(edit_post)
        fill_in 'post[title]', with: 'test-edit'
        fill_in 'post[body]', with: 'edit-body'
        click_button '投稿'
        expect(page).to have_content('投稿内容を更新しました！')
        expect(page).to have_content('test-edit')
        expect(current_path).to eq(posts_path)
      end
    end
    context '入力内容が正常' do
      it '投稿タイトルが20文字以内であり正常に投稿の更新ができること' do
        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'test-body'
        click_button '投稿'
        expect(page).to have_content('新規投稿が完了しました！')

        edit_post = Post.last
        visit post_path(edit_post)
        visit edit_post_path(edit_post)
        fill_in 'post[title]', with: 'a' * 20
        fill_in 'post[body]', with: 'edit-body'
        click_button '投稿'
        expect(page).to have_content('投稿内容を更新しました！')
        expect(current_path).to eq(posts_path)
        expect(page).to have_content('aaaaaa...')
      end
    end
    context '入力内容が正常' do
      it '投稿内容が500文字以内であり正常に投稿の更新ができること' do
        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'test-body'
        click_button '投稿'
        expect(page).to have_content('新規投稿が完了しました！')

        edit_post = Post.last
        visit post_path(edit_post)
        visit edit_post_path(edit_post)
        fill_in 'post[title]', with: 'test-edit'
        fill_in 'post[body]', with: 'a' * 500
        click_button '投稿'
        expect(page).to have_content('投稿内容を更新しました！')
        expect(page).to have_content('test-edit')
        expect(current_path).to eq(posts_path)
      end
    end
    context '入力内容が正常' do
      it '投稿に猫の情報を紐づけて、正常に投稿の更新ができること' do
        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'test-body'
        click_button '投稿'
        expect(page).to have_content('新規投稿が完了しました！')

        edit_post = Post.last
        visit post_path(edit_post)
        visit edit_post_path(edit_post)
        fill_in 'post[title]', with: 'test-edit'
        fill_in 'post[body]', with: 'edit-body'
        select me_cat.name, from: 'post[cat_id]'
        click_button '投稿'
        expect(page).to have_content('投稿内容を更新しました！')
        expect(current_path).to eq(posts_path)
        expect(page).to have_content('test-edit')
        expect(page).to have_content(me_cat.name)
      end
    end
    context '入力内容が正常' do
      it '投稿に猫の画像を添付して、正常に投稿の更新ができること' do
        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'test-body'
        click_button '投稿'
        expect(page).to have_content('新規投稿が完了しました！')

        edit_post = Post.last
        visit post_path(edit_post)
        visit edit_post_path(edit_post)
        fill_in 'post[title]', with: 'test-edit'
        fill_in 'post[body]', with: 'edit-body'
        select me_cat.name, from: 'post[cat_id]'
        image_path = Rails.root.join('spec/images/test-cat-photo.webp')
        attach_file 'avatar-file', image_path
        click_button '投稿'
        sleep 10
        expect(page).to have_content('投稿内容を更新しました！')
        expect(current_path).to eq(posts_path)
        expect(page).to have_content('test-edit')
        expect(page).to have_content(me_cat.name)
        expect(page).to have_selector("img[src$='test-cat-photo.webp']")
      end
    end
    context '投稿の削除の処理が正常' do
      it '自分の投稿が投稿詳細ページで削除できること' do
        visit new_post_path
        fill_in 'post[title]', with: 'test-title'
        fill_in 'post[body]', with: 'test-body'
        click_button '投稿'
        expect(page).to have_content('新規投稿が完了しました！')

        destroy_post = Post.last
        visit post_path(destroy_post)
        accept_alert do
          find("a[href='/posts/#{destroy_post.id}'][data-turbo-method='delete']").click
        end
        expect(page).to have_content('投稿を削除しました！')
        expect(current_path).to eq(posts_path)
        expect(page).not_to have_content(destroy_post.title)
      end
    end
  end
end
