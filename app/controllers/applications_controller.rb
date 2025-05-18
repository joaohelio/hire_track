class ApplicationsController < ApplicationController
  def index
    response = FetchApplications.new.call(
      filters: {active_jobs: true}
    )

    if response.failure?
      render json: { errors: response.failure }, status: :unprocessable_entity
    else
      render json: { data: response.success }, status: :ok
    end
  end
end
