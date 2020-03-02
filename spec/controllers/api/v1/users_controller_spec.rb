# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:create_response) do
    post :create, params: { user: { first_name: FFaker::Name.first_name,
                                    last_name: FFaker::Name.last_name,
                                    password: 'password',
                                    email: FFaker::Internet.email,
                                    image_url: FFaker::Avatar.image } }
  end
  let(:response_json) { Oj.load(create_response.body, symbol_keys: true) }
  let(:user_id) { response_json[:data][:user][:id] }
  let(:access_token) { response_json[:data][:token][:access_token] }
  let(:refresh_token) { response_json[:data][:token][:refresh_token] }
  let(:headers) { { 'Authorization': "Bearer #{access_token}" } }

  describe 'POST #create' do
    it 'returns http success' do
      expect(create_response).to have_http_status(:success)
    end
  end

  describe 'PUT #update' do
    it 'returns http success' do
      request.headers.merge! headers
      put :update, params: { user: { first_name: FFaker::Name.first_name,
                                     last_name: FFaker::Name.last_name,
                                     date_of_birth: FFaker::Time.datetime.to_i } }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    it 'returns http success for show with id' do
      request.headers.merge! headers
      get :show, params: { id: user_id }
      expect(response).to have_http_status(:success)
    end

    it 'returns http success for show my user data' do
      request.headers.merge! headers
      get :show, params: { id: :me }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #change_password' do
    it 'returns http success' do
      request.headers.merge! headers
      post :change_password, params: { user: { current_password: 'password', new_password: 'my_new_password' } }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #check_email' do
    it 'returns http success' do
      get :check_email, params: { user: { email: 'mike@showoff.ie' } }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #reset_password' do
    it 'returns http success' do
      post :reset_password, params: { user: { email: 'mike@showoff.ie' } }
      expect(response).to have_http_status(:success)
    end
  end
end
