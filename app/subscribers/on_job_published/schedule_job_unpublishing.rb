module OnJobPublished
  class ScheduleJobUnpublishing
    UNPUBLISH_PERIOD_DAYS = ENV.fetch("UNPUBLISH_PERIOD", 30).to_i.days

    def call(event)
      job = Job.find(event.job_id)
      JobUnpublisherJob.set(wait: UNPUBLISH_PERIOD_DAYS).perform_later(job.id)

      Rails.logger.tagged("jobs") do
        Rails.logger.tagged("unpublisher") do
          Rails.logger.info(
            "Scheduled job unpublishing for job #{job.id}, after #{UNPUBLISH_PERIOD_DAYS} days"
          )
        end
      end
    end
  end
end
