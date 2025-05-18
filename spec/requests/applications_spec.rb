require "rails_helper"

RSpec.describe ApplicationsController, type: :request do
  describe "GET /index" do
    let(:job1) { create(:job, title: "Developer") }
    let!(:job2) { create(:job, title: "Front-End") }
    let!(:application1) { create(:application, job: job1, candidate_name: "John Doe") }
    let!(:application2) { create(:application, job: job1, candidate_name: "Jane Doe") }
    let!(:application3) { create(:application, job: job1, candidate_name: "Alice Smith") }

    before do
      create(:event, :for_job, eventable: job1, status: "activated")
      create(:event, :for_application, eventable: application1, status: "interview")
      create(:event, :for_application, eventable: application2, status: "interview")
      create(:event, :for_application, eventable: application2, status: "rejected")
    end

    it "returns a list of applications with the jobs info" do
      get "/applications", as: :json

      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(json_response[:data].size).to eq(3)

      applications = json_response[:data]

      expect(applications).to match_array([
        a_hash_including(
          application_id: application1.id,
          job_title: job1.title,
          candidate_name: application1.candidate_name,
          application_status: "interview",
          number_of_notes: 0,
          last_interview_date: Date.today.iso8601,
        ),
        a_hash_including(
          application_id: application2.id,
          job_title: job1.title,
          candidate_name: application2.candidate_name,
          application_status: "rejected",
          number_of_notes: 0,
          last_interview_date: Date.today.iso8601,
        ),
        a_hash_including(
          application_id: application3.id,
          job_title: job1.title,
          candidate_name: application3.candidate_name,
          application_status: "applied",
          number_of_notes: 0,
          last_interview_date: nil,
        )
      ])
    end
  end
end
