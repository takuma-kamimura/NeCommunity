class Post < ApplicationRecord
  belongs_to :user
  belongs_to :cat, optional: true  # Optional: trueを使用して、Catが必須でないことを指定
  mount_uploader :photo, PostPhotoUploader # アバターアップローダー、useで使ってるものと同じものを使う。

  validates :title, presence: true, length: { maximum: 20 }
  validates :body, presence: true, length: { maximum: 500 }

  def self.ransackable_attributes(auth_object = nil)
    %w[title body]  # 検索可能な属性を指定してください
  end

  def self.ransackable_associations(auth_object = nil)
    %w[cat user]  # 検索可能な関連モデルを指定してください
  end
end
