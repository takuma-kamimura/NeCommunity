require 'rails_helper'

RSpec.describe "Admin::Tags", type: :system do
  let!(:admin) { create(:user, :admin)}
  let!(:post1) { create(:post) }
  let!(:post2) { create(:post) }
  let!(:post3) { create(:post) }
  let!(:tag1) { create(:tag) }
  let!(:tag2) { create(:tag) }
  before do
    post1.tags << tag1
    post2.tags << tag1
    post3.tags << tag2
    login_process_admin(admin)
  end
  describe '管理画面のタグ一覧テスト' do
    it 'タグ一覧が正常に表示されること' do
      click_link 'タグ管理'
      expect(page).to have_content('タグ一覧')
      expect(page).to have_link(tag1.name)
      expect(page).to have_link(tag2.name)
      tag1_create_datetime = tag1.created_at.strftime('%Y年%m月%d日 %H時%M分')
      tag2_create_datetime = tag2.created_at.strftime('%Y年%m月%d日 %H時%M分')
      expect(page).to have_content(tag1_create_datetime)
      expect(page).to have_content(tag2_create_datetime)
    end
    it 'タグに紐づいている投稿一覧が正常に表示され、リンクをクリックしたら投稿詳細ページへとアクセスできること' do
      click_link 'タグ管理'
      expect(page).to have_content('タグ一覧')
      expect(page).to have_link(tag1.name)
      expect(page).to have_link(tag2.name)
      tag1_create_datetime = tag1.created_at.strftime('%Y年%m月%d日 %H時%M分')
      tag2_create_datetime = tag2.created_at.strftime('%Y年%m月%d日 %H時%M分')
      expect(page).to have_content(tag1_create_datetime)
      expect(page).to have_content(tag2_create_datetime)

      click_link "詳細", id: "admin-tag-show-id-#{tag1.id}"
      sleep 1
      expect(current_path).to eq(admin_tag_path(tag1))
      expect(page).to have_link(post1.title)
      expect(page).to have_link(post2.title)
      click_link post1.title
      sleep 1
      expect(current_path).to eq(admin_post_path(post1))
      expect(page).to have_content('投稿詳細')
      expect(page).to have_content(post1.title)
      expect(page).to have_content(post1.body)
      post_create_datetime = post1.created_at.strftime('%Y年%m月%d日 %H時%M分')
      expect(page).to have_content(post_create_datetime)
      expect(current_path).to eq(admin_post_path(post1))
    end
    context '編集・更新・削除テスト' do
      it 'タグ一覧ページからタグ編集ページへ遷移できて、タグを編集し更新ができること' do
        click_link 'タグ管理'
        expect(page).to have_link(tag1.name)
        click_link "編集", id: "admin-tag-edit-id-#{tag1.id}"

        expect(page).to have_content('タグ編集')
        expect(current_path).to eq(edit_admin_tag_path(tag1))
        fill_in 'tag[name]', with: 'tag-edit'
        click_button '更新'
        sleep 1
        expect(page).to have_content('管理者用：更新が成功しました')
        expect(page).to have_content('tag-edit')
        tag1_create_datetime = tag1.created_at.strftime('%Y年%m月%d日 %H時%M分')
        expect(page).to have_content(tag1_create_datetime)
        expect(page).to have_content('タグに紐づいている投稿タイトル名')
        expect(page).to have_content(post1.title)
        expect(page).to have_content(post2.title)
        expect(page).not_to have_content(tag1.name)
      end
      it 'タグ一覧ページからタグを削除できること' do
        click_link 'タグ管理'
        expect(page).to have_link(tag1.name)
        accept_alert do
          click_link "削除", id: "admin-tag-delete-id-#{tag1.id}"
        end
        expect(page).to have_content('管理者用：削除しました')
        expect(current_path).to eq(admin_tags_path)
        expect(page).not_to have_link(tag1.name)
      end
      it 'タグ詳細ページからタグ編集ページへ遷移できて、タグを編集し更新ができること' do
        click_link 'タグ管理'
        click_link "詳細", id: "admin-tag-show-id-#{tag1.id}"
        sleep 1
        expect(current_path).to eq(admin_tag_path(tag1))
        expect(page).to have_content(tag1.name)
        expect(page).to have_link(post1.title)
        expect(page).to have_link(post2.title)
        click_link "編集"

        expect(page).to have_content('タグ編集')
        expect(current_path).to eq(edit_admin_tag_path(tag1))
        fill_in 'tag[name]', with: 'tag-edit'
        click_button '更新'
        sleep 1
        expect(page).to have_content('管理者用：更新が成功しました')
        expect(page).to have_content('tag-edit')
        tag1_create_datetime = tag1.created_at.strftime('%Y年%m月%d日 %H時%M分')
        expect(page).to have_content(tag1_create_datetime)
        expect(page).to have_content('タグに紐づいている投稿タイトル名')
        expect(page).to have_content(post1.title)
        expect(page).to have_content(post2.title)
        expect(page).not_to have_content(tag1.name)
      end
      it 'タグ詳細ページからタグを削除できること' do
        click_link 'タグ管理'
        expect(page).to have_link(tag1.name)
        click_link "詳細", id: "admin-tag-show-id-#{tag1.id}"
        sleep 1
        expect(current_path).to eq(admin_tag_path(tag1))
        expect(page).to have_link(post1.title)
        expect(page).to have_link(post2.title)
        accept_alert do
          click_link "削除"
        end
        expect(page).to have_content('管理者用：削除しました')
        expect(current_path).to eq(admin_tags_path)
        expect(page).not_to have_link(tag1.name)
      end
    end
  end
end
