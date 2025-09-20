class Job < ApplicationRecord
  belongs_to :company
  has_rich_text :description

  validates :title, presence: true
  validates :company_id, presence: true

  scope :published, -> { where.not(published_at: nil) }

  def publish!
    update(published_at: Time.current)
  end
end
