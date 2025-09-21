require "rails_helper"

RSpec.describe Job, type: :model do
  it_behaves_like "filterable" do
    let(:factory_name) { :job }
  end

  describe "#published?" do
    context "when job has published_at set" do
      let(:job) { create(:job, :published) }

      it "returns true" do
        expect(job).to be_published
      end
    end

    context "when job has no published_at" do
      let(:job) { create(:job, :unpublished) }

      it "returns false" do
        expect(job).not_to be_published
      end
    end
  end

  describe "#publish!" do
    context "when job is not published" do
      let(:job) { create(:job, :unpublished) }

      it "sets published_at to current time" do
        freeze_time do
          job.publish!

          expect(job.published_at).to eq(Time.current)
        end
      end
    end

    context "when job is already published" do
      let(:time_in_the_past) { 1.day.ago }
      let(:job) { create(:job, :published, published_at: time_in_the_past) }

      it "updates published_at to current time" do
        freeze_time do
          job.publish!

          expect(job.published_at).to eq(Time.current)
        end
      end
    end
  end
end
