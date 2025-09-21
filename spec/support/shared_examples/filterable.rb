RSpec.shared_examples "filterable" do
  describe ".search_by_query" do
    subject(:search_results) { described_class.search_by_query(query) }

    let(:matching_record) { create(factory_name, title: "Frontend Developer", location: "New York") }
    let(:non_matching_record) { create(factory_name, title: "Backend Developer", location: "San Francisco") }

    before do
      matching_record
      non_matching_record
    end

    context "when query matches title" do
      let(:query) { "Frontend" }

      it "returns matching records" do
        expect(search_results).to contain_exactly(matching_record)
      end
    end

    context "when query matches location" do
      let(:query) { "San Francisco" }

      it "returns matching records" do
        expect(search_results).to contain_exactly(non_matching_record)
      end
    end

    context "when query is case insensitive" do
      let(:query) { "frontend" }

      it "returns matching records" do
        expect(search_results).to contain_exactly(matching_record)
      end
    end

    context "when query has partial match" do
      let(:query) { "Developer" }

      it "returns all matching records" do
        expect(search_results).to contain_exactly(matching_record, non_matching_record)
      end
    end

    context "when query is blank" do
      let(:query) { "" }

      it "returns all records (scope is not applied)" do
        expect(search_results).to contain_exactly(matching_record, non_matching_record)
      end
    end

    context "when query is nil" do
      let(:query) { nil }

      it "returns all records (scope is not applied)" do
        expect(search_results).to contain_exactly(matching_record, non_matching_record)
      end
    end
  end

  describe ".sorted_by" do
    subject(:sorted_results) { described_class.sorted_by(sort_param) }

    let!(:first_record) { create(factory_name, title: "A Job", created_at: 3.days.ago) }
    let!(:second_record) { create(factory_name, title: "B Job", created_at: 2.days.ago) }
    let!(:third_record) { create(factory_name, title: "C Job", created_at: 1.day.ago) }

    context "when sorting by title ascending" do
      let(:sort_param) { "title ASC" }

      it "returns records in correct order" do
        expect(sorted_results).to eq([first_record, second_record, third_record])
      end
    end

    context "when sorting by title descending" do
      let(:sort_param) { "title DESC" }

      it "returns records in correct order" do
        expect(sorted_results).to eq([third_record, second_record, first_record])
      end
    end

    context "when sorting by created_at ascending" do
      let(:sort_param) { "created_at ASC" }

      it "returns records in correct order" do
        expect(sorted_results).to eq([first_record, second_record, third_record])
      end
    end

    context "when sorting by created_at descending" do
      let(:sort_param) { "created_at DESC" }

      it "returns records in correct order" do
        expect(sorted_results).to eq([third_record, second_record, first_record])
      end
    end

    context "when sort_param is blank" do
      let(:sort_param) { "" }

      it "returns all records (scope is not applied)" do
        expect(sorted_results.to_a).to match_array([first_record, second_record, third_record])
      end
    end

    context "when sort_param is nil" do
      let(:sort_param) { nil }

      it "returns all records (scope is not applied)" do
        expect(sorted_results.to_a).to match_array([first_record, second_record, third_record])
      end
    end
  end

  describe ".published" do
    subject(:published_results) { described_class.published }

    let!(:published_record) { create(factory_name, :published) }
    let!(:unpublished_record) { create(factory_name, :unpublished) }

    it "returns only published records" do
      expect(published_results).to contain_exactly(published_record)
    end
  end

  describe ".filtered" do
    subject(:filtered_results) { described_class.filtered(params) }

    let!(:published_frontend) { create(factory_name, :published, title: "Frontend Developer", location: "New York") }
    let!(:published_backend) { create(factory_name, :published, title: "Backend Developer", location: "San Francisco") }
    let!(:unpublished_fullstack) { create(factory_name, :unpublished, title: "Full Stack Developer", location: "Remote") }

    context "when no filters are applied" do
      let(:params) { {} }

      it "returns all records" do
        expect(filtered_results).to contain_exactly(published_frontend, published_backend, unpublished_fullstack)
      end
    end

    context "when filtering by published_only" do
      let(:params) { {published_only: true} }

      it "returns only published records" do
        expect(filtered_results).to contain_exactly(published_frontend, published_backend)
      end
    end

    context "when filtering by search query" do
      let(:params) { {q: "Frontend"} }

      it "returns matching records" do
        expect(filtered_results).to contain_exactly(published_frontend)
      end
    end

    context "when filtering by sort" do
      let(:params) { {sort: "title DESC"} }

      it "returns sorted records" do
        expect(filtered_results.to_a).to eq([unpublished_fullstack, published_frontend, published_backend])
      end
    end

    context "when combining all filters" do
      let(:params) { {published_only: true, q: "Developer", sort: "title ASC"} }

      it "applies all filters correctly" do
        expect(filtered_results.to_a).to eq([published_backend, published_frontend])
      end
    end

    context "when published_only is false" do
      let(:params) { {published_only: false} }

      it "returns all records" do
        expect(filtered_results).to contain_exactly(published_frontend, published_backend, unpublished_fullstack)
      end
    end
  end
end
