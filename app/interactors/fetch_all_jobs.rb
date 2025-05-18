# frozen_string_literal: true

class FetchAllJobs
  include Dry::Monads[:result]

  class ResponseModel < Dry::Struct
    attribute :job_id, Types::Strict::Integer
    attribute :job_status, Types::Strict::String
    attribute :number_of_hired, Types::Strict::Integer
    attribute :number_of_rejected, Types::Strict::Integer
    attribute :number_of_ongoing, Types::Strict::Integer
  end

  def initialize(repo: JobRepository.new)
    @repo = repo
  end

  def call
    jobs = repo.all.map do |job|
      ResponseModel.new(
        job_id: job.id,
        job_status: job.status,
        number_of_hired: job.applications.count(&:hired?),
        number_of_rejected: job.applications.count(&:rejected?),
        number_of_ongoing: job.applications.count(&:ongoing?),
      )
    end

    Success(jobs)
  end

  private

  attr_reader :repo
end
