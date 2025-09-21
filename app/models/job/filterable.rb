module Job::Filterable
  extend ActiveSupport::Concern

  included do
    scope :published, -> { where.not(published_at: nil) }
    scope :search_by_query, ->(query) {
      where("title ILIKE ? OR location ILIKE ?", "%#{query}%", "%#{query}%") if query.present?
    }
    scope :sorted_by, ->(sort_param) {
      order(sort_param) if sort_param.present?
    }
  end

  class_methods do
    def filtered(params = {})
      scope = all
      scope = scope.published if params[:published_only]
      scope = scope.search_by_query(params[:q]) if params[:q].present?
      scope = scope.sorted_by(params[:sort]) if params[:sort].present?
      scope
    end
  end
end
