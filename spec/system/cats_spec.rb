require 'rails_helper'

RSpec.describe "Cats", type: :system do
  let(:user) { create(:user) }
  let!(:cat_breed) do
    # 開発環境のデータをコピーしてテスト用データベースに保存
    CatBreed.create!(name: 'マンチカン')
  end
  describe '猫新規登録時のテスト' do
    before do
      login_process(user)
      visit root_path
      visit cats_path
    end
    context '入力に不備がある場合に登録に失敗し、エラーメッセージが表示されること' do
      it "名前がない場合はエラーメッセージが表示されること" do
        visit new_cat_path
        fill_in 'cat[name]', with: nil
        select '女の子', from: 'cat_gender'
        select cat_breed.name, from: 'cat[cat_breed_id]'
        click_button 'ネコを登録する'
        expect(page).to have_content('ネコの名前を入力してください')
        expect(page).to have_content('申し訳ありません 猫ちゃんの登録に失敗しました')
        expect(current_path).to eq(new_cat_path)
      end
    end
    context '入力に不備がある場合に登録に失敗し、エラーメッセージが表示されること' do
      it "性別を選択してない場合はエラーメッセージが表示されること" do
        visit new_cat_path
        fill_in 'cat[name]', with: 'test-cat'
        select '性別を選択してください', from: 'cat_gender'
        select cat_breed.name, from: 'cat[cat_breed_id]'
        click_button 'ネコを登録する'
        expect(page).to have_content('性別を入力してください')
        expect(page).to have_content('申し訳ありません 猫ちゃんの登録に失敗しました')
        expect(current_path).to eq(new_cat_path)
      end
    end
    context '入力に不備がある場合に登録に失敗し、エラーメッセージが表示されること' do
      it "猫の種類を選択してない場合はエラーメッセージが表示されること" do
        visit new_cat_path
        fill_in 'cat[name]', with: 'test-cat'
        select '女の子', from: 'cat_gender'
        select 'ネコの種類を選択してください', from: 'cat[cat_breed_id]'
        click_button 'ネコを登録する'
        expect(page).to have_content('猫種を入力してください')
        expect(page).to have_content('申し訳ありません 猫ちゃんの登録に失敗しました')
        expect(current_path).to eq(new_cat_path)
      end
    end
    context '入力に不備がある場合に登録に失敗し、エラーメッセージが表示されること' do
      it "猫の名前が16文字以上の場合はエラーメッセージが表示されること" do
        visit new_cat_path
        fill_in 'cat[name]', with: 'a' * 16
        select '女の子', from: 'cat_gender'
        select cat_breed.name, from: 'cat[cat_breed_id]'
        click_button 'ネコを登録する'
        expect(page).to have_content('ネコの名前は15文字以内で入力してください')
        expect(page).to have_content('申し訳ありません 猫ちゃんの登録に失敗しました')
        expect(current_path).to eq(new_cat_path)
      end
    end
    context '入力に不備がある場合に登録に失敗し、エラーメッセージが表示されること' do
      it "猫の紹介が201文字以上の場合はエラーメッセージが表示されること" do
        visit new_cat_path
        fill_in 'cat[name]', with: 'test'
        select '女の子', from: 'cat_gender'
        select cat_breed.name, from: 'cat[cat_breed_id]'
        fill_in 'cat[self_introduction]', with: 'a' * 201
        click_button 'ネコを登録する'
        expect(page).to have_content('ネコの紹介は200文字以内で入力してください')
        expect(page).to have_content('申し訳ありません 猫ちゃんの登録に失敗しました')
        expect(current_path).to eq(new_cat_path)
      end
    end
    context '入力内容が正常' do
      it "猫が正常に登録されること" do
        visit new_cat_path
        fill_in 'cat[name]', with: 'test'
        select '女の子', from: 'cat_gender'
        select cat_breed.name, from: 'cat[cat_breed_id]'
        click_button 'ネコを登録する'
        expect(page).to have_content('猫ちゃんの新規登録が完了しました！')
        expect(current_path).to eq(cats_path)
      end
    end
    context '入力内容が正常' do
      it "猫の紹介が200文字以内の場合でかつ、猫が正常に登録されること" do
        visit new_cat_path
        fill_in 'cat[name]', with: 'test'
        select '女の子', from: 'cat_gender'
        select cat_breed.name, from: 'cat[cat_breed_id]'
        fill_in 'cat[self_introduction]', with: 'a' * 200
        click_button 'ネコを登録する'
        expect(page).to have_content('猫ちゃんの新規登録が完了しました！')
        expect(current_path).to eq(cats_path)
      end
    end
  end
  describe '猫一覧ページの表示テスト' do
    let!(:cat) { create(:cat, user: user) }
    let!(:cat2) { create(:cat, user: user) }
    let!(:cat3) { create(:cat, user: user) }
    before do
      login_process(user)
      visit root_path
      visit cats_path
    end
      it "登録されている猫の一覧が表示されること" do
        expect(page).to have_content(cat.name)
        expect(page).to have_content(cat2.name)
        expect(page).to have_content(cat3.name)
      end
  end
  describe '猫詳細ページの表示テスト' do
    let!(:cat) { create(:cat, user: user) }
    before do
      login_process(user)
      visit root_path
      visit cats_path
    end
      it "登録されている猫の詳細が表示されること" do
        button_id = "cat-avatar-for-index-#{cat.id}"
        find("button##{button_id}").click
        expect(page).to have_content(cat.name)
        expect(page).to have_content('女の子')
        expect(page).to have_content(cat.cat_breed.name)
        expect(current_path).to eq(cats_path)
      end
  end
  describe '猫の編集・更新・削除のテスト' do
    before do
      login_process(user)
      visit root_path
      visit cats_path
    end
    context '入力に不備がある場合に更新に失敗し、エラーメッセージが表示されること' do
      it "名前がない場合はエラーメッセージが表示されること" do
        visit new_cat_path
        fill_in 'cat[name]', with: 'test-cat'
        select '女の子', from: 'cat_gender'
        select cat_breed.name, from: 'cat[cat_breed_id]'
        fill_in 'cat[self_introduction]', with: 'a' * 200
        click_button 'ネコを登録する'
        expect(page).to have_content('猫ちゃんの新規登録が完了しました！')
        expect(current_path).to eq(cats_path)

        cat = Cat.last
        button_id = "cat-avatar-for-index-#{cat.id}"
        find("button##{button_id}").click
        edit_button_id = "cat-edit-#{cat.id}"
        find("button##{edit_button_id}").click
        expect(page).to have_content(cat.name)
        expect(page).to have_content('女の子')
        expect(page).to have_content(cat.cat_breed.name)
        expect(page).to have_content(cat.self_introduction)
        fill_in 'cat[name]', with: nil
        select '男の子', from: 'cat_gender'
        fill_in 'cat[self_introduction]', with: 'b' * 200
        click_button 'ネコを登録する'
        expect(page).to have_content('申し訳ありません 猫ちゃんの情報の更新に失敗しました')
        expect(page).to have_content(cat.name)
        expect(current_path).to eq(cats_path)
      end
    end
    context '入力に不備がある場合に更新に失敗し、エラーメッセージが表示されること' do
      it "猫の名前が16文字以上の場合はエラーメッセージが表示されること" do
        visit new_cat_path
        fill_in 'cat[name]', with: 'test-cat'
        select '女の子', from: 'cat_gender'
        select cat_breed.name, from: 'cat[cat_breed_id]'
        fill_in 'cat[self_introduction]', with: 'a' * 200
        click_button 'ネコを登録する'
        expect(page).to have_content('猫ちゃんの新規登録が完了しました！')
        expect(current_path).to eq(cats_path)

        cat = Cat.last
        button_id = "cat-avatar-for-index-#{cat.id}"
        find("button##{button_id}").click
        edit_button_id = "cat-edit-#{cat.id}"
        find("button##{edit_button_id}").click
        expect(page).to have_content(cat.name)
        expect(page).to have_content('女の子')
        expect(page).to have_content(cat.cat_breed.name)
        expect(page).to have_content(cat.self_introduction)
        fill_in 'cat[name]', with: 'a' * 16
        select '男の子', from: 'cat_gender'
        fill_in 'cat[self_introduction]', with: 'b' * 200
        click_button 'ネコを登録する'
        expect(page).to have_content('申し訳ありません 猫ちゃんの情報の更新に失敗しました')
        expect(page).to have_content(cat.name)
        expect(current_path).to eq(cats_path)
      end
    end
    context '入力に不備がある場合に更新に失敗し、エラーメッセージが表示されること' do
      it "猫の紹介が201文字以上の場合はエラーメッセージが表示されること" do
        visit new_cat_path
        fill_in 'cat[name]', with: 'test-cat'
        select '女の子', from: 'cat_gender'
        select cat_breed.name, from: 'cat[cat_breed_id]'
        fill_in 'cat[self_introduction]', with: 'a' * 200
        click_button 'ネコを登録する'
        expect(page).to have_content('猫ちゃんの新規登録が完了しました！')
        expect(current_path).to eq(cats_path)

        cat = Cat.last
        button_id = "cat-avatar-for-index-#{cat.id}"
        find("button##{button_id}").click
        edit_button_id = "cat-edit-#{cat.id}"
        find("button##{edit_button_id}").click
        expect(page).to have_content(cat.name)
        expect(page).to have_content('女の子')
        expect(page).to have_content(cat.cat_breed.name)
        expect(page).to have_content(cat.self_introduction)
        fill_in 'cat[name]', with: 'test-edit-cat'
        select '男の子', from: 'cat_gender'
        fill_in 'cat[self_introduction]', with: 'b' * 201
        click_button 'ネコを登録する'
        expect(page).to have_content('申し訳ありません 猫ちゃんの情報の更新に失敗しました')
        expect(page).to have_content(cat.self_introduction)
        expect(current_path).to eq(cats_path)
      end
    end
    context '入力内容が正常' do
      it "登録した猫を編集し、更新できること" do
        visit new_cat_path
        fill_in 'cat[name]', with: 'test-cat'
        select '女の子', from: 'cat_gender'
        select cat_breed.name, from: 'cat[cat_breed_id]'
        fill_in 'cat[self_introduction]', with: 'a' * 200
        click_button 'ネコを登録する'
        expect(page).to have_content('猫ちゃんの新規登録が完了しました！')
        expect(current_path).to eq(cats_path)

        cat = Cat.last
        button_id = "cat-avatar-for-index-#{cat.id}"
        find("button##{button_id}").click
        edit_button_id = "cat-edit-#{cat.id}"
        find("button##{edit_button_id}").click
        expect(page).to have_content(cat.name)
        expect(page).to have_content('女の子')
        expect(page).to have_content(cat.cat_breed.name)
        expect(page).to have_content(cat.self_introduction)
        fill_in 'cat[name]', with: 'test-edit-cat'
        select '男の子', from: 'cat_gender'
        fill_in 'cat[self_introduction]', with: 'b' * 200
        click_button 'ネコを登録する'
        expect(page).to have_content('猫ちゃんの情報を更新しました！')
        expect(page).to have_content('test-edit-cat')
        expect(page).to have_content('男の子')
        expect(page).to have_content('b' * 200)
        expect(current_path).to eq(cats_path)
      end
    end
    context '削除処理が正常' do
      it "登録した猫を削除できること" do
        visit new_cat_path
        fill_in 'cat[name]', with: 'test-cat'
        select '女の子', from: 'cat_gender'
        select cat_breed.name, from: 'cat[cat_breed_id]'
        fill_in 'cat[self_introduction]', with: 'a' * 200
        click_button 'ネコを登録する'
        expect(page).to have_content('猫ちゃんの新規登録が完了しました！')
        expect(current_path).to eq(cats_path)
        cat = Cat.last
        button_id = "cat-avatar-for-index-#{cat.id}"
        find("button##{button_id}").click
        accept_alert do
          find("#cat-delete-#{cat.id}").click
        end
        expect(page).to have_content('猫ちゃんの情報を削除しました')
        expect(page).not_to have_content(cat.name)
        expect(current_path).to eq(cats_path)
      end
    end
  end
end
