class CatBreed < ApplicationRecord
  has_many :cats

  def self.ransackable_attributes(auth_object = nil)
    %w[name]  # 検索可能な属性を指定してください。検索時に猫の名前を検索できる
  end
end
