require 'rails_helper'

RSpec.describe "Lines", type: :system do
  before do
    login_process(user)
    visit posts_path
    find('#bars').click
    visit profile_path
  end
  describe 'Line通知機能' do
    context 'Line友達追加前' do
      let!(:user) { create(:user, line_id: '') }
      it '正しいLine友達追加QRコードが表示されていること' do
        visit line_events_show_path
        expect(page).to have_selector("img[src$='https://qr-official.line.me/gs/M_452ggkhv_GW.png?oat_content=qr']")
      end
    end
    context 'Line友達追加後' do
      let!(:user) { create(:user) }
      it 'Line連携を解除できるボタンが表示されていること' do
        expect(page).to have_content('連携したline_idを削除する')
      end
      it 'Line連携を解除できること' do
        expect(page).to have_content('連携したline_idを削除する')
        accept_alert do
          click_link '連携したline_idを削除する'
        end
        expect(page).to have_content('Line通知機能ON')
      end
    end
  end
end
