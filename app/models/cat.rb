class Cat < ApplicationRecord
  belongs_to :user
  belongs_to :cat_breed
  mount_uploader :avatar, AvatarUploader # アバターアップローダー
  enum gender: { Male: 0, Female: 1 }
  validates :name, presence: true
  validates :gender, presence: true
end
