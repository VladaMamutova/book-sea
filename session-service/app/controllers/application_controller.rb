class ApplicationController < ActionController::API
  include ExceptionHandler
  include Response

  def health
    render plain: 'OK'
  end
end
