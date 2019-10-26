class ApplicationController < ActionController::Base
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      Rails.env == "development" || (username == "code4miyazaki" && password == ENV["BASIC_AUTH_PASS"])
    end
  end
end
