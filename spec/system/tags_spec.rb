require 'rails_helper'

RSpec.describe "Tags", type: :system do
  let(:user) { create(:user) }
  let!(:cat_breed) do
    # 開発環境のデータをコピーしてテスト用データベースに保存
    CatBreed.create!(name: 'マンチカン')
  end
  let(:cat) { create(:cat) }
  before do
    login_process(user)
    visit root_path
    visit cats_path
  end
  describe 'タグのテスト' do
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
  end
end
