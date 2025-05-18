require "rails_helper"

RSpec.describe JobRepository do
  let(:active_jobs) { true }
  let(:filters) { { active_jobs: active_jobs } }

  let!(:job1) { create(:job, title: "Developer") }
  let!(:job2) { create(:job, title: "Designer") }

  let(:job_repository) { described_class.new }

  before do
    create(:event, :for_job, eventable: job1, status: "activated")

    app1 = create(:application, job: job1, candidate_name: "John Doe")
    app2 = create(:application, job: job1, candidate_name: "Jane Doe")

    create(:event, :for_application, eventable: app1, status: "interview")
    create(:event, :for_application, eventable: app2, status: "interview")
    create(:event, :for_application, eventable: app2, status: "rejected")
  end

  describe "#all" do
    context "when filters are provided" do
      it "filters jobs by job_status" do
        result = job_repository.all(filters)

        expect(result.size).to eq(1)

        active_jobs = result.first

        expect(active_jobs.status).to eq("activated")
        expect(active_jobs.applications.count).to eq(2)
      end
    end

    context "when no filters are provided" do
      it "returns all jobs without filtering" do
        result = job_repository.all

        expect(result.size).to eq(2)

        active_jobs = result.first
        deactivated_jobs = result.last

        expect(active_jobs.status).to eq("activated")
        expect(active_jobs.applications.count).to eq(2)

        expect(deactivated_jobs.status).to eq("deactivated")
        expect(deactivated_jobs.applications.count).to eq(0)
      end
    end
  end
end


