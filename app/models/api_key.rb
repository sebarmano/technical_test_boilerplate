class ApiKey < ApplicationRecord
  validates :key, presence: true, uniqueness: true
  validates :client, presence: true

  scope :active, -> { where(deactivated_at: nil) }
end
