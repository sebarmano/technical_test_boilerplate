require "rails_helper"

RSpec.describe OnJobPublished::ScheduleJobUnpublishing do
  let(:job) { create(:job) }
  let(:event) { JobPublished.new(job_id: job.id) }
  let(:subscriber) { described_class.new }

  describe "#call" do
    it "schedules JobUnpublisherJob with correct job_id" do
      allow(JobUnpublisherJob).to receive(:set)
        .with(wait: described_class::UNPUBLISH_PERIOD_DAYS)
        .and_return(JobUnpublisherJob)
      allow(JobUnpublisherJob).to receive(:perform_later)

      subscriber.call(event)

      expect(JobUnpublisherJob).to have_received(:perform_later).with(job.id)
    end

    it "logs the scheduled unpublishing" do
      allow(JobUnpublisherJob).to receive_message_chain(:set, :perform_later)
      allow(Rails.logger).to receive(:info)

      subscriber.call(event)

      expect(Rails.logger).to have_received(:info)
        .with(
          "Scheduled job unpublishing for job #{job.id}, after #{described_class::UNPUBLISH_PERIOD_DAYS} days"
        )
    end
  end
end
