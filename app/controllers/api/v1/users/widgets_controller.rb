class Api::V1::Users::WidgetsController < ApplicationController
  def index
    response = widgets_client.show(user_id, term)
    render json: response.body, status: response.code
  end

  private

  def widgets_client
    Showoff::Users::WidgetsClient.new(access_token)
  end

  def term
    params[:term]
  end

  def user_id
    return nil if params[:id] == 'me'

    params[:id]
  end
end
