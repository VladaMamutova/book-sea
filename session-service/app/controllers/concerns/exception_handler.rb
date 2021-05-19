module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :bad_request
    rescue_from JWT::DecodeError, JWT::ExpiredSignature, JWT::VerificationError, with: :unauthorized
  end

  private

  def bad_request(error)
    response = { message: 'Validation failed', details: error.record.errors.full_messages }
    json_response(response, :bad_request) # 400
  end

  def unauthorized(error)
    render json: { message: error.message }, status: :unauthorized # 401
  end
end
