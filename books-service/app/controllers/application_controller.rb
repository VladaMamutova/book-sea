class ApplicationController < ActionController::Base
  # include lib/error/error_handler.rb to handle errors on a global level
  include Error::ErrorHandler

  def health
    render plain: 'OK'
  end
end
