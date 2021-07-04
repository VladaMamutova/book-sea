module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, RuntimeError, with: :internal_server_error
    rescue_from ActiveRecord::RecordInvalid, with: :bad_request
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from Error::LimitExceeded, with: :conflict
  end

  private

  def bad_request(error)
    response = { message: 'Validation failed', details: error.record.errors.full_messages }
    json_response(response, :bad_request) # 400
  end

  def not_found(error)
    render json: { message: error.message }, status: :not_found # 404
  end

  def conflict(error)
    render json: { message: error.message }, status: :conflict # 409
  end

  def internal_server_error(error)
    render json: { message: error.message }, status: :internal_server_error # 500
  end
end
