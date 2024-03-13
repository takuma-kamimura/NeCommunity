class Cat < ApplicationRecord
  belongs_to :user
  belongs_to :cat_breed
  has_many :posts, dependent: :destroy
  mount_uploader :avatar, CatAvatarUploader # AvatarUploader # アバターアップローダー、useで使ってるものと同じものを使う。
  enum gender: { Male: 0, Female: 1 }
  validates :name, presence: true, length: { maximum: 15 }
  validates :gender, presence: true
  validates :self_introduction, length: { maximum: 200 }

  # プロフィール画像解除用として追加。
  attr_accessor :remove_cat_avatar
  before_save :remove_cat_avatar_if_needed

  def self.ransackable_attributes(auth_object = nil)
    %w[name]  # 検索可能な属性を指定してください。検索時に猫の名前を検索できる
  end

  def self.ransackable_associations(auth_object = nil)
    %w[health_records]  # 検索可能なモデル関連を指定してください
  end

  private

  # プロフィール画像解除用として追加。
  def remove_cat_avatar_if_needed
    self.avatar = nil if remove_cat_avatar == '1'
  end
end
