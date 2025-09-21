class JobUnpublisherJob < ApplicationJob
  queue_as :default

  def perform(job_id)
    job = Job.find(job_id)
    job.unpublish!
  end
end
