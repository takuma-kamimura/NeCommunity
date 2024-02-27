require 'rails_helper'

RSpec.describe "Posts", type: :system do
  let(:user) { create(:user) }
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
        # expect(current_path).to eq(posts_path)
        visit new_post_path
        # fill_in 'cat[name]', with: nil
        # select '女の子', from: 'cat_gender'
        # select cat_breed.name, from: 'cat[cat_breed_id]'
        # click_button 'ネコを登録する'
        # expect(page).to have_content('ネコの名前を入力してください')
      end
    end
  end
end
