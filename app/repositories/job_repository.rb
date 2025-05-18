# frozen_string_literal: true

class JobRepository
  def all(filters = {})
    dataset =
      if filters[:active_jobs]
        model
        .joins(:events)
        .eager_load(applications: :events)
        .where(events: { status: JobEntity::ACTIVATED })
      else
        model.eager_load(:events, applications: :events)
      end

    dataset.map do |job|
      JobEntity.build(job)
    end
  end

  private

  attr_reader :event_repo

  def model
    @model ||= Job
  end
end
