require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'Comment-Create' do
    it 'コメントの内容がない場合はコメントを投稿できないこと' do
      comment = build(:comment, body: nil)
      comment.valid?
      expect(comment.errors[:body]).to include('を入力してください')
    end
    it 'コメントが501文字以上の場合はコメントを投稿できないこと' do
      comment = build(:comment, body:'a' * 501)
      comment.valid?
      expect(comment.errors[:body]).to include('は500文字以内で入力してください')
    end
    it 'コメントに内容が入力され、コメントの投稿が有効' do
      comment = build(:comment, body:'test-comment')
      expect(comment).to be_valid
    end
    it 'コメントに500文字以内で内容が入力され、コメントの投稿が有効' do
      comment = build(:comment, body:'a' * 500)
      expect(comment).to be_valid
    end
  end
end
