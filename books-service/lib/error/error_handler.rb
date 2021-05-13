# Error module to Handle errors globally
# include Error::ErrorHandler in application_controller.rb
module Error
  module ErrorHandler
    def self.included(clazz)
      clazz.class_eval do
        rescue_from StandardError, RuntimeError do |e|
          respond(:internal_server_error, e.to_s)
        end
        rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
        rescue_from ActiveRecord::RecordInvalid, with: :invalid_response
      end
    end

    private

    def not_found_response(error)
      json = Helpers::Render.json(error.message)
      render json: json, status: :not_found # 404
    end

    def invalid_response(error)
      json = Helpers::Render.json('Validation failed', error.record.errors.full_messages)
      render json: json, status: :bad_request # 400
    end

    def respond(status, message)
      json = Helpers::Render.json(message)
      render json: json, status: status
    end
  end
end
