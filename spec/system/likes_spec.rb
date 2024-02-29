require 'rails_helper'

RSpec.describe "Likes", type: :system do
  let!(:user) { create(:user) }
  let!(:like_user) { create(:user) }
  let!(:like_post) { create(:post, user: like_user) }
  let!(:delete_like_post) { create(:post, user: like_user) }
  let!(:like) { create(:like, user: user, post: delete_like_post) }
  before do
    login_process(user)
    visit root_path
    visit posts_path
  end
  describe 'いいねのテスト' do
    it "投稿にいいねができること" do
      find("#like-button-for-post-#{like_post.id}").click
      find("#like-button-for-post-#{like_post.id}").click
      expect(page).not_to have_css("#like-button-for-post-#{like_post.id}")
      expect(page).to have_css("#unlike-button-for-post-#{like_post.id}")
    end
    it "投稿につけたいいねを削除できること" do
      find("#unlike-button-for-post-#{like.post.id}").click
      find("#unlike-button-for-post-#{like.post.id}").click
      expect(page).not_to have_css("#unlike-button-for-post-#{delete_like_post.id}")
      expect(page).to have_css("#like-button-for-post-#{delete_like_post.id}")
    end
  end
end
