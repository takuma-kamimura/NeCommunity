class Cat < ApplicationRecord
    belongs_to :user
    mount_uploader :avatar, AvatarUploader # アバターアップローダー
    enum gender: { Male: 0, Female: 1 }
end
