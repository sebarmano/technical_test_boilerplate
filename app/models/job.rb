class Job < ApplicationRecord
  include Filterable

  belongs_to :company
  has_rich_text :description

  validates :title, presence: true
  validates :company_id, presence: true

  def published?
    published_at.present?
  end

  def publish!
    update(published_at: Time.current)
  end

  def unpublish!
    update(published_at: nil)
  end
end
