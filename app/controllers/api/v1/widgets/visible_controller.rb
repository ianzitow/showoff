class Api::V1::Widgets::VisibleController < ApplicationController
  def index
    response = widgets_client.show(term)
    render json: response.body, status: response.code
  end

  private

  def widgets_client
    Showoff::Widgets::VisibleClient.new(access_token)
  end

  def term
    params[:term]
  end
end
