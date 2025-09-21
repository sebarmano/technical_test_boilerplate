class Job < ApplicationRecord
  belongs_to :company
  has_rich_text :description

  validates :title, presence: true
  validates :company_id, presence: true

  scope :published, -> { where.not(published_at: nil) }

  def published?
    published_at.present?
  end
  alias_method :published, :published?

  def publish!
    update(published_at: Time.current)
  end

  def unpublish!
    update(published_at: nil)
  end

  def as_json(options = {})
    options[:except] ||= [:created_at, :updated_at]
    options[:methods] ||= [:published]
    super
  end
end
