require 'rails_helper'

RSpec.describe 'GoogleMaps', type: :system do
  let(:user) { create(:user) }
  before do
    login_process(user)
    find('#bars').click
    visit search_maps_path
  end
  describe '動物病院の検索テスト', js: true do
    context 'マップの検索テスト' do
      it '好きな地名を押すと、mapにマーカーが表示され、病院がリストとなって表示されること' do
        expect(current_path).to eq(search_maps_path)
        fill_in 'location', with: '札幌'
        click_button '検索'
        sleep 5
        expect(page).to have_selector('#hospital')
        expect(page).to have_css('map#gmimap0')
      end
    end
    context 'グーグルマップで検索後の詳細ページ表示テスト' do
      it '好きな地名を押すと、mapにマーカーが表示され、病院がリストとなって表示され、リンクを押すと選択した動物病院の詳細ページへ遷移できること' do
        expect(current_path).to eq(search_maps_path)
        fill_in 'location', with: '札幌緑が丘動物病院'
        click_button '検索'
        sleep 5
        expect(page).to have_selector('#hospital')
        expect(page).to have_css('map#gmimap0')

        click_link('札幌緑が丘動物病院の詳細ページ')
        expect(page).to have_content('札幌緑が丘動物病院')
        expect(page).to have_content('北海道札幌市南区澄川５条１１丁目２−２')
        expect(current_path).to eq('/maps/search')
        expect(page).to have_link('公式HPはこちら')
      end
    end
  end
end
