# frozen_string_literal: true

class ApplicationEntity < Dry::Struct
  INTERVIEW = "interview"
  APPLIED = "applied"
  HIRED = "hired"
  REJECTED = "rejected"
  NOTE = "note"

  class Rejected < EventEntity; end

  class Interview < EventEntity
    attribute :interview_date, Types::Strict::Date
  end

  class Note < EventEntity
    attribute :content, Types::Strict::String
  end

  class Hired < EventEntity
    attribute :hire_date, Types::Strict::Date
  end

  ApplicationStatus = Types::Strict::String.enum(APPLIED, INTERVIEW, HIRED, REJECTED)

  attribute :id, Types::Strict::Integer
  attribute :candidate_name, Types::Strict::String
  attribute :status, ApplicationStatus
  attribute :events, Types::Array.of(EventEntity)

  def self.build(application)
    app_events = application.events.sort_by(&:id)

    new(
      id: application.id,
      candidate_name: application.candidate_name,
      status: app_events.reject {|e| e.status == NOTE }.last&.status || APPLIED,
      events: app_events.map { |e| event_build(e) },
    )
  end

  def interview?
    status == INTERVIEW
  end

  def hired?
    status == HIRED
  end

  def rejected?
    status == REJECTED
  end

  def ongoing?
    [APPLIED, INTERVIEW].include?(status)
  end

  def self.event_build(event)
    case event.status
    when INTERVIEW
      Interview.new(
        id: event.id,
        status: event.status,
        interview_date: event.data["interview_date"].to_date,
      )
    when HIRED
      Hired.new(
        id: event.id,
        status: event.status,
        hire_date: event.data["hire_date"].to_date,
      )
    when REJECTED
      Rejected.new(
        id: event.id,
        status: event.status,
      )
    when NOTE
      Note.new(
        id: event.id,
        status: event.status,
        content: event.data["content"],
      )
    else
      raise ArgumentError, "Unknown application status: #{event.status}"
    end
  end
end
