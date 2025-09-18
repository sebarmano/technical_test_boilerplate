require 'rails_helper'

RSpec.describe Company, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      company = build(:company)
      expect(company).to be_valid
    end

    it 'is invalid without a name' do
      company = build(:company, name: nil)
      expect(company).not_to be_valid
      expect(company.errors[:name]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'has many jobs' do
      company = create(:company)
      job1 = create(:job, company: company)
      job2 = create(:job, company: company)

      expect(company.jobs).to include(job1, job2)
      expect(company.jobs.count).to eq(2)
    end

    it 'destroys associated jobs when company is destroyed' do
      company = create(:company)
      job = create(:job, company: company)

      expect { company.destroy }.to change { Job.count }.by(-1)
    end

    it 'can have a logo attached' do
      company = create(:company)
      expect(company.logo).to be_a(ActiveStorage::Attached::One)
    end

    it 'has rich text description' do
      company = create(:company)
      company.description = "This is a company description"
      expect(company.description).to be_present
    end
  end
end
