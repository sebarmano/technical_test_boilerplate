class Api::V1::JobsController < ApiController
  include Paginatable

  before_action :set_job, only: [:show, :update]

  def index
    filtered_jobs = build_filtered_jobs
    result = paginate_collection(filtered_jobs)

    render json: {
      jobs: result[:collection],
      pagination: result[:pagination]
    }
  end

  def show
    render json: @job
  end

  def create
    @job = Job.new(job_params.except(:published))
    if @job.save
      publish_job
      render json: @job, status: :created, location: @job
    else
      render json: @job.errors, status: :unprocessable_content
    end
  end

  def update
    if @job.update(job_params.except(:published))
      publish_job
      render json: @job
    else
      render json: @job.errors, status: :unprocessable_content
    end
  end

  private

  def set_job
    @job = Job.find(params[:id])
  end

  def build_filtered_jobs
    filter_params = {
      q: params[:q],
      sort: params[:sort]
    }
    filter_params[:published_only] = true if filter_published?

    Job.filtered(filter_params)
  end

  def filter_published?
    params[:published].in? ["true", "yes", true]
  end

  def job_params
    params.expect(job: [:company_id, :location, :title, :description, :published])
  end

  def publish_job
    Jobs::Publisher.new.publish(@job) if publish_job?
  end

  def publish_job?
    job_params[:published].in? ["true", true]
  end
end
