# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  before(:all) do
    @client = Showoff::AuthenticationClient.new
  end

  describe 'POST /oauth/token' do
    it 'creates a new token' do
      response = @client.create(
        username: 'mike@showoff.ie',
        password: 'password'
      )
      expect(response.code).to eq(200)
    end

    it 'refresh my token' do
      response = @client.refresh
      expect(response.code).to eq(200)
    end

    it 'revokes my token' do
      response = @client.revoke
      expect(response.code).to eq(200)
    end
  end
end
