# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  before(:all) do
    @client = Showoff::UsersClient.new
  end

  describe 'POST /users' do
    it 'creates a new user' do
      response = @client.create(
        first_name: FFaker::Name.first_name,
        last_name: FFaker::Name.last_name,
        password: 'password',
        email: FFaker::Internet.email,
        image_url: FFaker::Avatar.image
      )
      expect(response.code).to eq(200)
    end
  end

  describe 'UPDATE /users/me' do
    it 'updates a user' do
      response = @client.update(
        first_name: FFaker::Name.first_name,
        last_name: FFaker::Name.last_name,
        date_of_birth: FFaker::Time.datetime.to_i,
        image_url: FFaker::Avatar.image
      )
      expect(response.code).to eq(200)
    end
  end
end
