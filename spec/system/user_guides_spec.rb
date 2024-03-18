require 'rails_helper'

RSpec.describe "UserGuides", type: :system do
  describe '使い方ページの表示テスト' do
    context 'ログイン前' do
      it '使い方ページへアクセスできること' do
        visit root_path
        find('#bars').click
        sleep 1
        click_link 'How to Use'
        sleep 1
        expect(current_path).to eq(guide_tops_path)
        expect(page).to have_content('猫好きな人はぜひ使ってみてください')
        expect(page).to have_content('使い方')
      end
    end
    context 'ログイン後' do
      let(:user) { create(:user) }
      it '使い方ページへアクセスできること' do
        login_process(user)
        visit root_path
        find('#bars').click
        sleep 1
        click_link 'How to Use'
        sleep 1
        expect(current_path).to eq(guide_tops_path)
        expect(page).to have_content('猫好きな人はぜひ使ってみてください')
        expect(page).to have_content('使い方')
      end
    end
  end
end
