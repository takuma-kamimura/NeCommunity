class Post < ApplicationRecord
  belongs_to :user
  belongs_to :cat, optional: true  # Optional: trueを使用して、Catが必須でないことを指定
  mount_uploader :photo, PostPhotoUploader # アバターアップローダー、useで使ってるものと同じものを使う。
end
