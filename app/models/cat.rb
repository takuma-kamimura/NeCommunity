class Cat < ApplicationRecord
  belongs_to :user
  belongs_to :cat_breed
  has_many :posts, dependent: :destroy
  has_many :health_records, dependent: :destroy
  mount_uploader :avatar, AvatarUploader # アバターアップローダー、useで使ってるものと同じものを使う。
  enum gender: { Male: 0, Female: 1 }
  validates :name, presence: true
  validates :gender, presence: true
  validates :self_introduction, length: { maximum: 500 }

  def self.ransackable_attributes(auth_object = nil)
    %w[name]  # 検索可能な属性を指定してください。検索時に猫の名前を検索できる
  end

  # def self.ransackable_associations(auth_object = nil)
  #   %w[body user]  # 検索可能なモデル関連を指定してください
  # end
end
