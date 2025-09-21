module Jobs
  class Publisher
    def publish(job)
      return if job.published?

      job.publish!
      publish_job_event(job)
    end

    private

    def publish_job_event(job)
      event = JobPublished.new(job_id: job.id)
      ActiveEventStore.publish(event)
    end
  end
end
