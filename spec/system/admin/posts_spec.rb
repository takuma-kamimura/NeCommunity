require 'rails_helper'

RSpec.describe "Admin::Posts", type: :system do
  let!(:general1) { create(:user, :general)}
  let!(:general2) { create(:user, :general)}
  let!(:general3) { create(:user, :general)}
  let!(:admin) { create(:user, :admin)}

  let!(:cat_breed) {create(:cat_breed)}
  
  let!(:cat1) { create(:cat, user: general1, cat_breed: cat_breed) }
  let!(:cat2) { create(:cat, user: general2, cat_breed: cat_breed) }
  let!(:cat3) { create(:cat, user: general3, cat_breed: cat_breed) }
  let!(:cat4) { create(:cat, user: admin, cat_breed: cat_breed) }

  let!(:post1) { create(:post, user: general1, cat: cat1) }
  let!(:post2) { create(:post, user: general2, cat: cat2) }
  let!(:post3) { create(:post, user: general3, cat: cat3) }
  let!(:post4) { create(:post, user: admin) }
  
  before do
    login_process_admin(admin)
  end
  describe '管理画面の投稿一覧表示テスト' do
    it '投稿一覧が正常に表示されること' do
      click_link '投稿管理'
      expect(page).to have_content(general1.name)
      expect(page).to have_content(post1.title)
      expect(page).to have_content(post1.body)
      expect(page).to have_content(cat1.name)
      expect(page).to have_content(general2.name)
      expect(page).to have_content(post2.title)
      expect(page).to have_content(post2.body)
      expect(page).to have_content(cat2.name)
      expect(page).to have_content(general3.name)
      expect(page).to have_content(post3.title)
      expect(page).to have_content(post3.body)
      expect(page).to have_content(cat3.name)
      expect(page).to have_content(admin.name)
      expect(page).to have_content(post4.title)
      expect(page).to have_content(post4.body)
      expect(page).not_to have_content(cat4.name)
      expect(current_path).to eq(admin_posts_path)
    end

  end

end
