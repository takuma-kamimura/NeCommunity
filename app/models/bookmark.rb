class Bookmark < ApplicationRecord
  belongs_to :post # postがbookmarkを所有
  belongs_to :user # userがpostを所有。
  validates :user_id, uniqueness: { scope: :post_id } # user_idの重複を避ける。
end
