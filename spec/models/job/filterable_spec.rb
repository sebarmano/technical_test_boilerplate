require "rails_helper"

RSpec.describe Job::Filterable, type: :model do
  describe "when included in Job model" do
    it "adds the expected scopes and methods" do
      expect(Job).to respond_to(:published)
      expect(Job).to respond_to(:search_by_query)
      expect(Job).to respond_to(:sorted_by)
      expect(Job).to respond_to(:filtered)
    end
  end

  describe "concern integration" do
    it "allows Job to use filterable behavior" do
      expect(Job.ancestors).to include(Job::Filterable)
    end
  end
end
