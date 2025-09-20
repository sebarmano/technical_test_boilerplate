class Api::V1::JobsController < ApiController
  before_action :set_job, only: [:show, :update]

  def index
    render json: filtered_jobs
  end

  def show
    render json: @job
  end

  def create
    @job = Job.new(job_params.except(:published))
    if @job.save
      @job.publish! if publish_job?
      render json: @job, status: :created, location: @job
    else
      render json: @job.errors, status: :unprocessable_entity
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

  def filtered_jobs
    jobs = filter_published? ? Job.published : Job.all
    jobs = jobs.where("title ILIKE ? OR location ILIKE ?", "%#{query}%", "%#{query}%") if query.present?
    jobs = jobs.order(sort) if sort.present?
    jobs
  end

  def query
    params[:q]
  end

  def sort
    params[:sort]
  end

  def filter_published?
    params[:published].in? ["true", "yes"]
  end

  def job_params
    params.expect(job: [:company_id, :location, :title, :description, :published])
  end

  def publish_job
    @job.publish! if publish_job?
  end

  def publish_job?
    job_params[:published] == "true"
  end
end
