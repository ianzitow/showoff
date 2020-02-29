# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Widgets', type: :request do
  let(:response_hidden) do
    @client.create(
      name: FFaker::Lorem.sentence(3),
      description: FFaker::Lorem.paragraph,
      kind: 'hidden'
    )
  end
  let(:response_visible) do
    @client.create(
      name: FFaker::Lorem.sentence(3),
      description: FFaker::Lorem.paragraph,
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
    @client = Showoff::WidgetsClient.new(authentication_client.access_token, authentication_client.refresh_token)
  end

  describe 'POST /widgets' do
    it 'creates a new hidden widget' do
      expect(response_hidden.code).to eq(200)
    end

    it 'creates a new visible widget' do
      expect(response_visible.code).to eq(200)
    end
  end

  describe 'UPDATE /widgets' do
    it 'updates my widget' do
      response = @client.update(
        widget_id,
        name: FFaker::Lorem.sentence(3),
        description: FFaker::Lorem.paragraph,
      )
      expect(response.code).to eq(200)
    end
  end

  describe 'DESTROY /widgets' do
    it 'destroys my widget' do
      response = @client.destroy(widget_id)
      expect(response.code).to eq(200)
    end
  end

  describe 'GET /widgets' do
    it 'shows my widgets' do
      response = @client.show
      expect(response.code).to eq(200)
    end
  end
end
