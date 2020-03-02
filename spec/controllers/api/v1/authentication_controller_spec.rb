require 'rails_helper'

RSpec.describe Api::V1::AuthenticationController, type: :controller do

  let(:create_response) { post :create, params: { authentication: { username: 'mike@showoff.ie', password: 'password' } } }
  let(:response_json) { Oj.load(create_response.body, symbol_keys: true) }
  let(:access_token) { response_json[:data][:token][:access_token] }
  let(:refresh_token) { response_json[:data][:token][:refresh_token] }
  let(:headers) { { 'Authorization': "Bearer #{access_token}" } }

  describe "GET #create" do
    it "returns http success" do
      expect(create_response).to have_http_status(:success)
    end
  end

  describe "GET #refresh" do
    it "returns http success" do
      request.headers.merge! headers
      post :refresh, params: {authentication: {refresh_token: refresh_token}}
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #revoke" do
    it "returns http success" do
      request.headers.merge! headers
      post :revoke, params: {authentication: {access_token: access_token}}
      expect(response).to have_http_status(:success)
    end
  end

end
