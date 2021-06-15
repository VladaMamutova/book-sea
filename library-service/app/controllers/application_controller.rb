class ApplicationController < ActionController::Base
  include Error::ErrorHandler

  def health
    render plain: 'OK'
  end
end
