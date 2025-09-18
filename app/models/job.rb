class Job < ApplicationRecord
  belongs_to :company
  has_rich_text :description

  validates :title, presence: true
  validates :company_id, presence: true

  scope :published, -> { where.not(published_at: nil) }
end
