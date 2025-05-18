# frozen_string_literal: true

class JobEntity < Dry::Struct
  ACTIVATED = "activated"
  DEACTIVATED = "deactivated"

  class Activated < EventEntity; end

  class Deactivated < EventEntity; end

  JobStatus = Types::Strict::String.enum(ACTIVATED, DEACTIVATED)

  attribute :id, Types::Strict::Integer
  attribute :title, Types::Strict::String
  attribute :description, Types::Strict::String
  attribute :status, JobStatus
  attribute :applications, Types::Array.of(ApplicationEntity)
  attribute :events, Types::Array.of(EventEntity)

  def self.build(job)
    job_events = job.events.sort_by(&:id)

    new(
      id: job.id,
      title: job.title,
      description: job.description,
      status: job_events.last&.status || DEACTIVATED,
      events: job_events.map {|e| event_build(e) },
      applications: job.applications.map {|app| ApplicationEntity.build(app)},
    )
  end

  def active?
    status == ACTIVATED
  end

  def self.event_build(event)
    case event.status
    when ACTIVATED
      Activated.new(
        id: event.id,
        status: event.status,
      )
    when DEACTIVATED
      Deactivated.new(
        id: event.id,
        status: event.status,
      )
    else
      raise ArgumentError, "Unknown event status: #{event.status}"
    end
  end
end
