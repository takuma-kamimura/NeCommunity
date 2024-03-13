require 'rails_helper'

RSpec.describe Cat, type: :model do
  describe 'Cat-Create' do
    it '猫の名前がない場合は登録できないこと' do
      cat = build(:cat, name: nil)
      cat.valid?
      expect(cat.errors[:name]).to include('を入力してください')
    end
    it '猫の猫種がない場合は登録できないこと' do
      cat = build(:cat, cat_breed: nil)
      cat.valid?
      expect(cat.errors[:cat_breed]).to include('を入力してください')
    end
    it '猫の性別がない場合は登録できないこと' do
      cat = build(:cat, gender: nil)
      cat.valid?
      expect(cat.errors[:gender]).to include('を入力してください')
    end
    it '猫の名前が16文字以上の場合は登録できないこと' do
      cat = build(:cat, name: 'a' * 16)
      cat.valid?
      expect(cat.errors[:name]).to include('は15文字以内で入力してください')
    end
    it '猫の紹介が201文字以上の場合は登録できないこと' do
      cat = build(:cat, self_introduction: 'a' * 201)
      cat.valid?
      expect(cat.errors[:self_introduction]).to include('は200文字以内で入力してください')
    end
    it '猫の名前が15文字以内で、猫種・性別が入力され猫の登録が有効' do
      cat = build(:cat)
      expect(cat).to be_valid
    end
  end
end
