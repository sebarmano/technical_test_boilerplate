require "rails_helper"

RSpec.describe Jobs::Publisher do
  let(:job) { create(:job, :unpublished) }
  let(:publisher) { described_class.new }

  describe "#publish" do
    it "publishes the job at the current time" do
      freeze_time do
        publisher.publish(job)

        expect(job.reload.published_at).to eq(Time.current)
      end
    end

    it "publishes a JobPublished event with correct job_id" do
      expect { publisher.publish(job) }
        .to have_published_event(JobPublished)
        .with(job_id: job.id)
    end

    context "when job is already published" do
      let(:job) { create(:job, :published) }

      it "does not update the published_at timestamp" do
        original_time = job.published_at

        publisher.publish(job)

        expect(job.reload.published_at).to eq(original_time)
      end

      it "does not publish the event" do
        allow(ActiveEventStore).to receive(:publish)

        publisher.publish(job)

        expect(ActiveEventStore).not_to have_received(:publish)
      end
    end
  end
end
