# frozen_string_literal: true

class FetchApplications
  include Dry::Monads[:result]

  class RequestModel < Dry::Validation::Contract
    params do
      required(:filters).hash do
        optional(:active_jobs).filled(:bool?)
      end
    end
  end

  class ResponseModel < Dry::Struct
    attribute :application_id, Types::Strict::Integer
    attribute :job_title, Types::Strict::String
    attribute :candidate_name, Types::Strict::String
    attribute :application_status, Types::Strict::String
    attribute :number_of_notes, Types::Strict::Integer
    attribute :last_interview_date, Types::Strict::Date.optional
  end

  def initialize(repo: JobRepository.new)
    @repo = repo
  end

  def call(params)
    request = RequestModel.new.call(params)

    return Failure(request.errors.to_h) unless request.success?

    filters = request.to_h[:filters]

    jobs = repo.all(filters)

    applications = jobs.flat_map do |job|
      job.applications.map do |application|
        ResponseModel.new(
          application_id: application.id,
          job_title: job.title,
          candidate_name: application.candidate_name,
          application_status: application.status,
          number_of_notes: application.events.count {|e| e.status == ApplicationEntity::NOTE},
          last_interview_date: last_interview_date(application),
        )
      end
    end

    Success(applications)
  end

  private

  attr_reader :repo

  def last_interview_date(application)
    application.events.select {|e| e.status == ApplicationEntity::INTERVIEW}.last&.interview_date
  end
end
