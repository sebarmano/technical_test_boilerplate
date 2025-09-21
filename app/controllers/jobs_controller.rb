class JobsController < ApplicationController
  include Paginatable

  def index
    filtered_jobs = Job.filtered(params.merge(published_only: true))
    result = paginate_collection(filtered_jobs)

    @jobs = result[:collection]
    @pagination = result[:pagination]
  end

  def show
    @job = Job.find(params[:id])
  end
end
