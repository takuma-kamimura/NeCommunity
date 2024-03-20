class Tag < ApplicationRecord
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags, dependent: :destroy

  validates :name, uniqueness: true # タグの重複を避ける

  def self.ransackable_attributes(auth_object = nil)
    %w[name]  # 検索時にtagの名前を検索できる
  end
end
