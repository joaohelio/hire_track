require "rails_helper"

RSpec.describe JobsController, type: :request do
  describe "GET /index" do
    let!(:job1) { create(:job, title: "Developer") }
    let!(:job2) { create(:job, title: "Designer") }

    before do
      create(:event, :for_job, eventable: job1, status: "activated")

      app1 = create(:application, job: job1, candidate_name: "John Doe")
      app2 = create(:application, job: job1, candidate_name: "Jane Doe")
      create(:application, job: job2, candidate_name: "Alice Smith")

      create(:event, :for_application, eventable: app1, status: "interview")
      create(:event, :for_application, eventable: app2, status: "interview")
      create(:event, :for_application, eventable: app2, status: "rejected")
    end

    it "returns a list of jobs with the applications info" do
      get "/jobs", as: :json

      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)

      expect(json_response[:data].size).to eq(2)
      expect(json_response[:data]).to contain_exactly(
        a_hash_including(
          job_id: job1.id,
          job_status: "activated",
          number_of_hired: 0,
          number_of_rejected: 1,
          number_of_ongoing: 1,
        ),
        a_hash_including(
          job_id: job2.id,
          job_status: "deactivated",
          number_of_hired: 0,
          number_of_rejected: 0,
          number_of_ongoing: 1,
        )
      )
    end
  end
end
