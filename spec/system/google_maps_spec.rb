require 'rails_helper'

RSpec.describe "GoogleMaps", type: :system do
  let(:user) { create(:user) }
  before do
    login_process(user)
    find('#bars').click
    visit search_maps_path
  end
  describe '動物病院の検索テスト', js: true do
    context 'ログアウト状態の場合' do
      it "好きな地名を押すと、mapにマーカーが表示され、病院がリストとなって表示されること" do
        fill_in 'location', with: '札幌'
        click_button '検索'
        # sleep 5
        expect(page).to have_selector('#hospital')
        expect(page).to have_css('map#gmimap0')
        expect(current_path).to eq(search_maps_path)
        # map#gmimap0 area", visible: false
        # # expect(page).to have_css('div[title="まつい犬猫病院"]', visible: true)
        # expect(page).to have_css('div[title="まつい犬猫病院"]', visible: true, wait: 30)
        puts page.body
      end
    end
  end
end
