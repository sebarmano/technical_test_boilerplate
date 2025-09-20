require "rails_helper"

RSpec.describe ApiKey, type: :model do
  describe ".active" do
    context "when there are active and deactivated API keys" do
      it "returns only active API keys" do
        active_key1 = create(:api_key, deactivated_at: nil)
        active_key2 = create(:api_key, deactivated_at: nil)
        deactivated_key = create(:api_key, deactivated_at: 1.day.ago)

        active_keys = ApiKey.active

        expect(active_keys).to contain_exactly(active_key1, active_key2)
        expect(active_keys).not_to include(deactivated_key)
      end
    end

    context "when all API keys are active" do
      it "returns all API keys" do
        key1 = create(:api_key, deactivated_at: nil)
        key2 = create(:api_key, deactivated_at: nil)

        active_keys = ApiKey.active

        expect(active_keys).to contain_exactly(key1, key2)
      end
    end

    context "when all API keys are deactivated" do
      it "returns empty collection" do
        create(:api_key, deactivated_at: 1.day.ago)
        create(:api_key, deactivated_at: 2.days.ago)

        active_keys = ApiKey.active

        expect(active_keys).to be_empty
      end
    end

    context "when no API keys exist" do
      it "returns empty collection" do
        active_keys = ApiKey.active

        expect(active_keys).to be_empty
      end
    end
  end
end
