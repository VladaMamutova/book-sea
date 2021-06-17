# Error module to Handle errors globally
# include Error::ErrorHandler in application_controller.rb
module Error
  module ErrorHandler
    def self.included(clazz)
      clazz.class_eval do
        rescue_from StandardError, RuntimeError do |e|
          respond(:internal_server_error, e.to_s)
        end
        rescue_from AuthorizationError, JWT::DecodeError, JWT::VerificationError, with: :unauthorized
        rescue_from JWT::ExpiredSignature, with: :forbidden
        rescue_from ActiveRecord::RecordNotFound, with: :not_found
        rescue_from ActiveRecord::RecordInvalid, with: :invalid
      end
    end

    private

    def unauthorized(error)
      json = Helpers::Render.json("Access denied: #{error.message}")
      render json: json, status: :unauthorized # 401
    end

    def forbidden(_error)
      json = Helpers::Render.json('Access denied: the access token has expired')
      render json: json, status: :forbidden # 403
    end

    def not_found(error)
      json = Helpers::Render.json(error.message)
      render json: json, status: :not_found # 404
    end

    def invalid(error)
      json = Helpers::Render.json('Validation failed', error.record.errors.full_messages)
      render json: json, status: :bad_request # 400
    end

    def respond(status, message)
      json = Helpers::Render.json(message)
      render json: json, status: status
    end
  end
end
