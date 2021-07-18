class ApplicationController < ActionController::API
  include Error
  include ErrorHandler

  def health
    render plain: 'OK'
  end
end
