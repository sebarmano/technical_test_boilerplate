module Paginatable
  extend ActiveSupport::Concern

  DEFAULT_PER_PAGE = 10
  MAX_PER_PAGE = 100

  included do
    helper_method :pagination_url_for
  end

  def pagination_url_for(page_num, request_params, additional_params = [])
    base_params = [:q, :sort, :per_page]
    all_params = base_params + additional_params

    permitted_params = request_params.permit(*all_params)
    url_for(permitted_params.merge(page: page_num))
  end

  private

  def paginate_collection(collection)
    paginated_collection = collection
      .limit(per_page(DEFAULT_PER_PAGE, MAX_PER_PAGE))
      .offset((page - 1) * per_page(DEFAULT_PER_PAGE, MAX_PER_PAGE))

    {
      collection: paginated_collection,
      pagination: pagination_metadata(collection)
    }
  end

  def page
    @page ||= [params[:page].to_i, 1].max
  end

  def per_page(default, max)
    @per_page ||= if params[:per_page].present?
      params[:per_page].to_i.clamp(1, max)
    else
      default
    end
  end

  def pagination_metadata(collection)
    {
      current_page: page,
      per_page: per_page(DEFAULT_PER_PAGE, MAX_PER_PAGE),
      total_pages: total_pages(collection),
      total_count: total_count(collection)
    }
  end

  def total_count(collection)
    @total_count ||= collection.count
  end

  def total_pages(collection)
    @total_pages ||= (total_count(collection).to_f / per_page(DEFAULT_PER_PAGE, MAX_PER_PAGE)).ceil
  end
end
