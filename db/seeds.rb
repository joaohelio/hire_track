# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create jobs
jobs = [
  {title: "Senior Ruby Developer", description: "Experienced Ruby developer needed for our team."},
  {title: "Frontend Developer", description: "React/Vue.js developer for our new product."},
  {title: "DevOps Engineer", description: "Help us improve our infrastructure and deployment processes."},
  {title: "Product Manager", description: "Lead our product initiatives and roadmap."},
  {title: "UX Designer", description: "Create amazing user experiences for our customers."},
]
created_jobs = jobs.map do |job_attrs|
  Job.create!(job_attrs)
end

# Activate the first four jobs
activated_jobs = created_jobs[0..3]
activated_jobs.each do |job|
  Event.create!(
    eventable: job,
    status: "activated",
  )
end

# Deactivate one job that was previously activated
Event.create!(
  eventable: activated_jobs[0],
  status: "deactivated",
)

# Create applications for active jobs
job_applications = [
  # job 1
  {job: activated_jobs[0], candidate_name: "Alice"},
  {job: activated_jobs[0], candidate_name: "Joao"},
  # job 2
  {job: activated_jobs[1], candidate_name: "Bob"},
  # job 3
  {job: activated_jobs[2], candidate_name: "Charlie"},
  # job 4
  {job: activated_jobs[3], candidate_name: "Frank"},
  {job: activated_jobs[3], candidate_name: "Ted"},
]
created_job_applications = job_applications.map do |app_attrs|
  Application.create!(app_attrs)
end

# create interview for applications
created_job_applications[0..4].each do |application|
  Event.create!(
    eventable: application,
    status: "interview",
    data: { interview_date: "2025-01-01" },
  )
end

# Create events for applications
# job 1
Event.create!(
  eventable: created_job_applications[0],
  status: "rejected",
)

Event.create!(
  eventable: created_job_applications[1],
  status: "hired",
  data: { hire_date: "2025-01-04" },
)

Event.create!(
  eventable: created_job_applications[1],
  status: "note",
  data: { content: "great candidate" },
)

# job 2
Event.create!(
  eventable: created_job_applications[2],
  status: "hired",
  data: { hire_date: "2025-01-06" },
)

# job 3
Event.create!(
  eventable: created_job_applications[3],
  status: "rejected",
)

Event.create!(
  eventable: created_job_applications[3],
  status: "note",
  data: { content: "profile doesnt fit" },
)
