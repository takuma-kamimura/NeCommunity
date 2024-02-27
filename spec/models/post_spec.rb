require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'Post-Create' do
    it "投稿のタイトルがない場合は投稿できないこと" do
      post = build(:post, title: nil, cat: nil)
      post.valid?
      expect(post.errors[:title]).to include("を入力してください")
    end
    it "投稿の内容がない場合は投稿できないこと" do
      post = build(:post, body: nil, cat: nil)
      post.valid?
      expect(post.errors[:body]).to include("を入力してください")
    end
    it "投稿のタイトルが21文字以上の場合は投稿できないこと" do
      post = build(:post, title: 'a' * 21, cat: nil)
      post.valid?
      expect(post.errors[:title]).to include("は20文字以内で入力してください")
    end
    it "投稿の内容が501文字以上の場合は投稿できないこと" do
      post = build(:post, body: 'a' * 501, cat: nil)
      post.valid?
      expect(post.errors[:body]).to include("は500文字以内で入力してください")
    end
    it "投稿のタイトルが20文字以内かつ内容が500文字以内の場合は投稿が有効" do
      post = build(:post, cat: nil)
      expect(post).to be_valid
    end
    it "投稿に猫の情報を紐付けて、かつ投稿のタイトルが20文字以内かつ内容が500文字以内の場合は投稿が有効" do
      cat = build(:cat)
      post = build(:post, cat: cat)
      expect(post).to be_valid
    end
  end
end
