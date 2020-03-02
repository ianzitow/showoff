require 'rails_helper'

RSpec.describe Api::V1::WidgetsController, type: :controller do

  let(:create_auth_response) do
    Showoff::AuthenticationClient.new.create(username: 'mike@showoff.ie', password: 'password')
  end
  let(:response_auth_json) { Oj.load(create_auth_response.body, symbol_keys: true) }
  let(:access_token) { response_auth_json[:data][:token][:access_token] }
  let(:headers) { { 'Authorization': "Bearer #{access_token}" } }
  let(:create_response) do
    request.headers.merge! headers
    post :create, params: { widget: { name: FFaker::Lorem.sentence(3),
                                      description: FFaker::Lorem.paragraph,
                                      kind: 'visible' } }
  end
  let(:response_json) { Oj.load(create_response.body, symbol_keys: true) }
  let(:widget_id) { response_json[:data][:widget][:id] }

  describe "POST #create" do
    it "returns http success" do
      expect(create_response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      request.headers.merge! headers
      get :show
      expect(response).to have_http_status(:success)
    end
  end

  describe "PUT #update" do
    it "returns http success" do
      request.headers.merge! headers
      put :update, params: { id: widget_id, widget: { name: FFaker::Lorem.sentence(3) } }
      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE #destroy" do
    it "returns http success" do
      request.headers.merge! headers
      delete :destroy, params: { id: widget_id }
      expect(response).to have_http_status(:success)
    end
  end

end
