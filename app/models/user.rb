class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :cats, dependent: :destroy
  has_many :posts, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255 } # 7/09追加　新規登録時に名前が空欄だとエラーで処理を受け付けなくする。
  validates :email, presence: true
  # 下記、gem sorceryの案内ホームページで書かれている内容のため追記
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, uniqueness: true
  validates :self_introduction, length: { maximum: 500 }
  mount_uploader :avatar, AvatarUploader # アバターアップローダー

  def self.ransackable_attributes(auth_object = nil)
    %w[name]  # 検索可能な属性を指定してください
  end

  def self.ransackable_associations(auth_object = nil)
    %w[cat body]  # 検索可能な関連を指定してください
  end

  def own?(object)
    id == object&.user_id
  end
end
