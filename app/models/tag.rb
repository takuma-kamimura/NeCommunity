class Tag < ApplicationRecord
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    %w[name]  # 検索可能な属性を指定してください。検索時にuserの名前を検索できる
  end
end
