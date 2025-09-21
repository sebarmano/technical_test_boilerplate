require "rails_helper"

RSpec.describe JobUnpublisherJob, type: :job do
  let(:job) { create(:job, :published) }

  describe "#perform" do
    it "unpublishes the job" do
      described_class.perform_now(job.id)

      expect(job.reload.published_at).to be_nil
    end

    it "is queued on the default queue" do
      expect(described_class.new.queue_name).to eq("default")
    end

    context "when job is already unpublished" do
      let(:job) { create(:job, :unpublished) }

      it "keeps the job unpublished" do
        described_class.perform_now(job.id)

        expect(job.reload.published_at).to be_nil
      end
    end
  end
end
