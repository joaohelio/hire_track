class JobsController < ApplicationController
  def index
    response = FetchAllJobs.new.call

    if response.failure?
      render json: { errors: response.failure }, status: :unprocessable_entity
    else
      render json: { data: response.success }, status: :ok
    end
  end
end
