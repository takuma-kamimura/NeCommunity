class HealthRecord < ApplicationRecord
  belongs_to :cat
  validates :note, presence: true, length: { maximum: 500 }
end
