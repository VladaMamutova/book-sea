module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, RuntimeError, with: :internal_server_error
    rescue_from Error::RecordInvalid, with: :bad_request
    rescue_from Error::RecordNotFound, with: :not_found
    rescue_from Error::BooksProcessError, Error::LibraryProcessError, with: :unprocessable_entity

    rescue_from RestClient::ExceptionWithResponse do |e|
      response = JSON.parse(e.response.body)

      case e.response.code
      when 400
        bad_request(Error::RecordInvalid.new(response['message'], response['details']))
      when 404
        not_found(Error::RecordNotFound.new(response['message']))
      else
        internal_server_error(StandardError.new(response['message']))
      end
    end
  end

  private

  def bad_request(error)
    response = { message: error.message, details: error.details }
    render json: response, status: :bad_request # 400
  end

  def unauthorized(error)
    render json: { message: error.message }, status: :unauthorized # 401
  end

  def forbidden(error)
    render json: { message: error.message }, status: :forbidden # 403
  end

  def not_found(error)
    render json: { message: error.message }, status: :not_found # 404
  end

  def unprocessable_entity(error)
    render json: { message: error.message }, status: :unprocessable_entity # 422
  end

  def internal_server_error(error)
    render json: { message: error.message }, status: :internal_server_error # 500
  end
end
