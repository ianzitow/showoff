class Api::V1::WidgetsController < ApplicationController

  def create
    response = widgets_client.create(widget_params)
    render json: response.body, status: response.code
  end

  def show
    response = widgets_client.show
    render json: response.body, status: response.code
  end

  def update
    response = widgets_client.update(widget_id, widget_params)
    render json: response.body, status: response.code
  end

  def destroy
    response = widgets_client.destroy(widget_id)
    render json: response.body, status: response.code
  end

  private

  def widget_params
    params.require(:widget).permit(:name, :description, :kind)
  end

  def widgets_client
    Showoff::WidgetsClient.new(access_token)
  end

  def widget_id
    params[:id]
  end
end
