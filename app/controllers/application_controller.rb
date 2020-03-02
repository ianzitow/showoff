class ApplicationController < ActionController::Base
  def access_token
    request.headers['Authorization']&.split&.last
  end
end
