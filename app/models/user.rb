class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :name, presence: true, length: { maximum: 255 } # 7/09追加　新規登録時に名前が空欄だとエラーで処理を受け付けなくする。
  validates :email, presence: true
  # 下記、gem sorceryの案内ホームページで書かれている内容のため追記
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, uniqueness: true
end