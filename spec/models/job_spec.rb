require 'rails_helper'

RSpec.describe Job, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      job = create(:job)
      expect(job).to be_valid
    end

    it 'is invalid without a title' do
      job = build(:job, title: nil)
      expect(job).not_to be_valid
      expect(job.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without a company_id' do
      job = build(:job, company: nil)
      expect(job).not_to be_valid
      expect(job.errors[:company_id]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'belongs to a company' do
      job = create(:job)
      expect(job.company).to be_present
      expect(job.company).to be_a(Company)
    end

    it 'has rich text description' do
      job = create(:job)
      job.description = "This is a job description"
      expect(job.description).to be_present
    end
  end

  describe 'scopes' do
    describe '.published' do
      it 'returns only jobs with published_at set' do
        published_job = create(:job, published_at: 1.day.ago)
        unpublished_job = create(:job, published_at: nil)

        published_jobs = Job.published

        expect(published_jobs).to include(published_job)
        expect(published_jobs).not_to include(unpublished_job)
      end
    end
  end
end
