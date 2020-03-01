# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users/Widgets', type: :request do
  let(:hidden_sentence) { FFaker::Lorem.sentence(3) }
  let(:visible_sentence) { FFaker::Lorem.sentence(3) }
  let(:response_hidden) do
    @widgets_client.create(
      name: hidden_sentence,
      description: FFaker::Lorem.paragraph(2),
      kind: 'hidden'
    )
  end
  let(:response_visible) do
    @widgets_client.create(
      name: visible_sentence,
      description: FFaker::Lorem.paragraph(2),
      kind: 'visible'
    )
  end
  let(:response_visible_json) { Oj.load(response_visible, symbol_keys: true) }
  let(:widget_id) { response_visible_json[:data][:widget][:id] }

  before(:all) do
    authentication_client = Showoff::AuthenticationClient.new
    authentication_client.create(
      username: 'mike@showoff.ie',
      password: 'password'
    )
    @widgets_client = Showoff::WidgetsClient.new(authentication_client.access_token, authentication_client.refresh_token)
    @users_widgets_clients = Showoff::Users::WidgetsClient.new(authentication_client.access_token, authentication_client.refresh_token)
  end

  describe 'GET /users/me/widgets' do
    it 'shows my widgets' do
      expect(response_visible.code).to eq(200)
      expect(response_hidden.code).to eq(200)
      response = @users_widgets_clients.show
      expect(response.code).to eq(200)
      response_json = Oj.load(response.body, symbol_keys: true)
      kinds = response_json[:data][:widgets].pluck(:kind)
      expect(kinds).to all(include('hidden'))
      widgets_ids = response_json[:data][:widgets].pluck(:id)
      expect(widgets_ids).to include(widget_id)
    end

    it 'shows only my widgets with a term' do
      response = @users_widgets_clients.show(nil, hidden_sentence.split[-2])
      expect(response.code).to eq(200)
      response_json = Oj.load(response.body, symbol_keys: true)
      expect(response_json[:data][:widgets].count).to be > 0
    end
  end

  describe 'GET /users/:id/widgets' do
    it 'shows widgets from a user' do
      user_id = response_visible_json[:data][:widget][:user][:id]
      response = @users_widgets_clients.show(user_id)
      expect(response.code).to eq(200)
      response_json = Oj.load(response.body, symbol_keys: true)
      kinds = response_json[:data][:widgets].pluck(:kind)
      expect(kinds).to all(eq('visible'))
      expect(response_json[:data][:widgets].pluck(:id)).to include(response_visible_json[:data][:widget][:id])
    end

    it 'shows widgets from a user with a term' do
      user_id = response_visible_json[:data][:widget][:user][:id]
      response = @users_widgets_clients.show(user_id, visible_sentence.split[-2])
      expect(response.code).to eq(200)
      response_json = Oj.load(response.body, symbol_keys: true)
      expect(response_json[:data][:widgets].count).to be > 0
    end
  end
end
