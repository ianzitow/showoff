class Api::V1::UsersController < ApplicationController
  def create
    response = users_client.create(user_params)
    render json: response.body, status: response.code
  end

  def update
    response = users_client.update(user_params)
    render json: response.body, status: response.code
  end

  def show
    response = users_client.show(user_id == 'me' ? nil : user_id)
    render json: response.body, status: response.code
  end

  def change_password
    response = users_client.change_password(user_params)
    render json: response.body, status: response.code
  end

  def check_email
    response = users_client.check_email(user_params)
    render json: response.body, status: response.code
  end

  def reset_password
    response = users_client.reset_password(user_params)
    render json: response.body, status: response.code
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :password, :email, :image_url, :date_of_birth, :current_password, :new_password)
  end

  def users_client
    Showoff::UsersClient.new(access_token)
  end

  def user_id
    params[:id]
  end
end
