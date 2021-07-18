class ApplicationController < ActionController::API
  include ErrorHandler

  def health
    render plain: 'OK'
  end
end
