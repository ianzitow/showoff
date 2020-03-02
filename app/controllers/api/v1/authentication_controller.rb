# frozen_string_literal: true

class Api::V1::AuthenticationController < ApplicationController
  def create
    response = authentication_client.create(username: authentication_params[:username],
                                            password: authentication_params[:password])
    render json: response.body, status: response.code
  end

  def revoke
    response = authentication_client.revoke
    render json: response.body, status: response.code
  end

  def refresh
    response = authentication_client.refresh
    render json: response.body, status: response.code
  end

  private

  def authentication_params
    params.require(:authentication).permit(:username, :password, :refresh_token)
  end

  def refresh_token
    authentication_params[:refresh_token]
  end

  def authentication_client
    Showoff::AuthenticationClient.new(access_token, refresh_token)
  end
end
