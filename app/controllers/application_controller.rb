class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  def access_token
    request.headers['Authorization']&.split&.last
  end
end
