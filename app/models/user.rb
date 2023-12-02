class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :cats, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  # いいね設定
  has_many :likes, dependent: :destroy # 「user」も「like」もお互いを所有。多対多の関係。
  has_many :like_posts, through: :likes, source: :post # likeを経由してuserに紐づいたpostを取得することができる。
  # ブックマーク設定
  has_many :bookmarks, dependent: :destroy # 「user」も「bookmark」もお互いを所有。多対多の関係。
  has_many :bookmark_posts, through: :bookmarks, source: :post # bookmarkを経由してuserに紐づいたpostを取得することができる。

  validates :name, presence: true, length: { maximum: 255 } # 7/09追加　新規登録時に名前が空欄だとエラーで処理を受け付けなくする。
  validates :email, presence: true
  # 下記、gem sorceryの案内ホームページで書かれている内容のため追記
  validates :password, presence: true, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, uniqueness: true
  validates :self_introduction, length: { maximum: 500 }
  validates :reset_password_token, uniqueness: true, allow_nil: true # パスワードリセット用
  mount_uploader :avatar, AvatarUploader # アバターアップローダー
  enum role: { general: 0, admin: 1 }

  # プロフィール画像解除用として追加。
  attr_accessor :remove_avatar
  before_save :remove_avatar_if_needed

  def self.ransackable_attributes(auth_object = nil)
    %w[name email]  # 検索可能な属性を指定してください。検索時にuserの名前を検索できる
  end

  def self.ransackable_associations(auth_object = nil)
    %w[cat body]  # 検索可能な関連を指定してください
  end

  def own?(object)
    id == object&.user_id
  end

  # いいね処理
  def like(post)
    # 中間テーブルlike_postsに格納
    like_posts << post
  end

  def unlike(post)
    like_posts.delete(post)
  end

  def like?(post)
    like_posts.include?(post)
  end

  # ブックマーク処理
  def bookmark(post)
    # 中間テーブルlike_postsに格納
    bookmark_posts << post
  end

  def unbookmark(post)
    bookmark_posts.delete(post)
  end

  def bookmark?(post)
    bookmark_posts.include?(post)
  end

  private

  # プロフィール画像解除用として追加。
  def remove_avatar_if_needed
    self.avatar = nil if remove_avatar == '1'
  end
end
