class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  validates :body, presence: true, length: { maximum: 500 }

  def self.ransackable_attributes(auth_object = nil)
    %w[body]  # 検索時に猫の名前を検索できる
  end
end
