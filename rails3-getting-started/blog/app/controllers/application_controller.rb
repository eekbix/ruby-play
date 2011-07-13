class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def authenticate
    authenticate_or_request_with_http_basic do |user, pass|
      # hardcoded credentials, for now
      user == 'admin' && pass == 'password'
    end
  end
end
