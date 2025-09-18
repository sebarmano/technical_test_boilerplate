class JobsController < ApplicationController
  def index
    @query = params[:q]
    @sort = params[:sort]
    @jobs = Job.published
    @jobs = @jobs.where("title ILIKE ? OR location ILIKE ?", "%#{@query}%", "%#{@query}%") if @query.present?
    @jobs = @jobs.order(@sort) if @sort.present?
  end

  def show
    @job = Job.find(params[:id])
  end
end
