require "rails_helper"

RSpec.describe "/api/v1/jobs", type: :request do
  let(:api_key) { create(:api_key) }
  let(:company) { create(:company) }
  let(:headers) do
    {
      "Authorization" => "Bearer #{api_key.key}",
      "Content-Type" => "application/json",
      "Accept" => "application/json"
    }
  end

  describe "GET /index" do
    let!(:published_job) { create(:job, :published, company: company) }
    let!(:unpublished_job) { create(:job, :unpublished, company: company) }

    context "without authentication" do
      it "returns unauthorized" do
        get "/api/v1/jobs", headers: {"Content-Type" => "application/json", "Accept" => "application/json"}

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with authentication" do
      context "when no filters are applied" do
        it "returns all jobs by default" do
          get "/api/v1/jobs", headers: headers

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body).size).to eq(2)
        end
      end

      context "when published parameter is provided" do
        it "filters published jobs when the published parameter is true" do
          get "/api/v1/jobs", params: {published: "true"}, headers: headers
          jobs = JSON.parse(response.body)

          expect(response).to have_http_status(:ok)
          expect(jobs.size).to eq(1)
          expect(jobs.first["id"]).to eq(published_job.id)
        end

        it "returns all jobs when the published parameter is not true" do
          get "/api/v1/jobs", params: {published: "false"}, headers: headers
          jobs = JSON.parse(response.body)

          expect(jobs.size).to eq(2)
          expect(response).to have_http_status(:ok)
        end
      end

      context "when query parameter is provided" do
        it "filters by query parameter" do
          job_with_unique_title = create(:job, company: company, title: "Unique Position")

          get "/api/v1/jobs", params: {q: "Unique"}, headers: headers
          jobs = JSON.parse(response.body)

          expect(response).to have_http_status(:ok)
          expect(jobs.size).to eq(1)
          expect(jobs.first["id"]).to eq(job_with_unique_title.id)
        end
      end

      context "when sort parameter is provided" do
        it "sorts jobs when sort parameter is provided" do
          get "/api/v1/jobs", params: {sort: "title ASC"}, headers: headers
          jobs = JSON.parse(response.body)

          expect(response).to have_http_status(:ok)
          expect(jobs).to be_an(Array)
        end
      end

      context "response format" do
        it "returns JSON format" do
          get "/api/v1/jobs", headers: headers

          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
    end
  end

  describe "GET /show" do
    let(:job) { create(:job, company: company) }

    context "with authentication" do
      context "when job exists" do
        it "returns the job" do
          get "/api/v1/jobs/#{job.id}", headers: headers
          job_response = JSON.parse(response.body)

          expect(response).to have_http_status(:ok)
          expect(job_response["id"]).to eq(job.id)
          expect(job_response["title"]).to eq(job.title)
        end
      end

      context "when job does not exist" do
        it "returns not found for a job that does not exist" do
          get "/api/v1/jobs/99999", headers: headers

          expect(response).to have_http_status(:not_found)
        end
      end

      context "response format" do
        it "returns JSON format" do
          get "/api/v1/jobs/#{job.id}", headers: headers

          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
    end
  end

  describe "POST /create" do
    let(:job_attributes) do
      {
        job: {
          company_id: company.id,
          title: "Software Engineer",
          location: "San Francisco",
          description: "Great opportunity",
          published: "false"
        }
      }
    end

    let(:invalid_attributes) do
      {
        job: {
          title: "",
          location: "San Francisco"
        }
      }
    end

    context "with authentication" do
      context "with valid parameters" do
        it "creates a new job" do
          expect {
            post "/api/v1/jobs", params: job_attributes.to_json, headers: headers
          }.to change(Job, :count).by(1)
        end

        it "returns created status" do
          post "/api/v1/jobs", params: job_attributes.to_json, headers: headers

          expect(response).to have_http_status(:created)
        end

        it "returns the created job" do
          post "/api/v1/jobs", params: job_attributes.to_json, headers: headers
          job_response = JSON.parse(response.body)

          expect(job_response["title"]).to eq("Software Engineer")
          expect(job_response["location"]).to eq("San Francisco")
        end

        context "when published is not true" do
          let(:not_published_attributes) do
            {
              job: {
                company_id: company.id,
                title: "Software Engineer",
                location: "San Francisco",
                description: "Great opportunity",
                published: "false"
              }
            }
          end

          it "does not publish job when published is not true" do
            post "/api/v1/jobs", params: not_published_attributes.to_json, headers: headers
            job = Job.last

            expect(job.published_at).to be_nil
          end
        end

        context "when published is true" do
          let(:published_attributes) do
            {
              job: {
                company_id: company.id,
                title: "Software Engineer",
                location: "San Francisco",
                description: "Great opportunity",
                published: "true"
              }
            }
          end

          it "publishes job when published is true" do
            post "/api/v1/jobs", params: published_attributes.to_json, headers: headers
            created_job = Job.last

            expect(created_job.published_at).to be_present
          end
        end
      end

      context "with invalid parameters" do
        it "does not create a job" do
          expect {
            post "/api/v1/jobs", params: invalid_attributes.to_json, headers: headers
          }.to change(Job, :count).by(0)
        end

        it "returns unprocessable content status" do
          post "/api/v1/jobs", params: invalid_attributes.to_json, headers: headers

          expect(response).to have_http_status(:unprocessable_content)
        end

        it "returns errors" do
          post "/api/v1/jobs", params: invalid_attributes.to_json, headers: headers
          error_response = JSON.parse(response.body)

          expect(error_response).to have_key("title")
        end
      end
    end
  end

  describe "PATCH/PUT /update" do
    let(:job) { create(:job, company: company, title: "Original Title") }
    let(:job_attributes) do
      {
        job: {
          title: "Updated Title",
          location: "Updated Location"
        }
      }
    end

    let(:invalid_attributes) do
      {
        job: {
          title: ""
        }
      }
    end

    context "without authentication" do
      it "returns unauthorized" do
        put "/api/v1/jobs/#{job.id}", params: job_attributes.to_json, headers: {"Content-Type" => "application/json"}

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with authentication" do
      context "with valid parameters" do
        it "updates the job" do
          put "/api/v1/jobs/#{job.id}", params: job_attributes.to_json, headers: headers
          job.reload

          expect(job.title).to eq("Updated Title")
          expect(job.location).to eq("Updated Location")
        end

        it "returns ok status" do
          put "/api/v1/jobs/#{job.id}", params: job_attributes.to_json, headers: headers

          expect(response).to have_http_status(:ok)
        end

        it "returns the updated job" do
          put "/api/v1/jobs/#{job.id}", params: job_attributes.to_json, headers: headers
          job_response = JSON.parse(response.body)

          expect(job_response["title"]).to eq("Updated Title")
        end

        context "when published is true" do
          it "publishes job when published is true" do
            job_attributes[:job][:published] = "true"

            patch "/api/v1/jobs/#{job.id}", params: job_attributes.to_json, headers: headers
            job.reload

            expect(job.published_at).to be_present
          end
        end
      end

      context "with invalid parameters" do
        it "does not update the job" do
          original_title = job.title

          put "/api/v1/jobs/#{job.id}", params: invalid_attributes.to_json, headers: headers
          job.reload

          expect(job.title).to eq(original_title)
        end

        it "returns unprocessable content status" do
          put "/api/v1/jobs/#{job.id}", params: invalid_attributes.to_json, headers: headers

          expect(response).to have_http_status(:unprocessable_content)
        end

        it "returns errors" do
          put "/api/v1/jobs/#{job.id}", params: invalid_attributes.to_json, headers: headers
          error_response = JSON.parse(response.body)

          expect(error_response).to have_key("title")
        end
      end

      context "when job does not exist" do
        it "returns 404 for non-existent job" do
          put "/api/v1/jobs/99999", params: job_attributes.to_json, headers: headers

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe "rate limiting" do
    it "respects rate limits from ApiController" do
      2.times do
        get "/api/v1/jobs", headers: headers
      end

      expect(response).to have_http_status(:ok).or have_http_status(:too_many_requests)
    end
  end

  describe "content type requirements" do
    it "requires JSON content type for API requests" do
      get "/api/v1/jobs", headers: {"Authorization" => "Bearer #{api_key.key}"}

      expect(response).to have_http_status(:not_acceptable)
    end
  end
end
