class ApplicationController < ActionController::Base
  include Error
  include ErrorHandler

  def health
    render plain: 'OK'
  end
end
