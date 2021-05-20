module ExceptionHandler
  extend ActiveSupport::Concern

  class NotAuthorized < StandardError; end

  included do
    rescue_from StandardError, RuntimeError, with: :internal_server_error
    rescue_from ActiveRecord::RecordInvalid, with: :bad_request
    rescue_from JWT::ExpiredSignature, with: :forbidden
    rescue_from NotAuthorized, JWT::DecodeError, JWT::VerificationError, with: :unauthorized
  end

  private

  def bad_request(error)
    response = { message: 'Validation failed', details: error.record.errors.full_messages }
    json_response(response, :bad_request) # 400
  end

  def unauthorized(error)
    render json: { message: error.message }, status: :unauthorized # 401
  end

  def forbidden(error)
    render json: { message: error.message }, status: :forbidden # 403
  end

  def internal_server_error(error)
    render json: { message: error.message }, status: :internal_server_error # 500
  end
end
