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

  describe 'GET /users' do
    it 'shows my profile' do
      response = @client.show
      expect(response.code).to eq(200)
    end

    it 'shows someone else profile' do
      response = @client.show(1)
      expect(response.code).to eq(200)
    end
  end

  describe 'POST /users/me/password' do
    it 'changes my password' do
      response = @client.change_password(
        current_password: 'password',
        new_password: 'newpassword'
      )
      expect(response.code).to eq(200)
    end
  end

  describe 'GET /users/email' do
    it 'checks if email exists' do
      response = @client.check_email(email: 'test@showoff.ie')
      expect(response.code).to eq(200)
    end
  end

  describe 'POST /users/reset_password' do
    it 'checks if email exists' do
      response = @client.check_email(email: 'test@showoff.ie')
      expect(response.code).to eq(200)
    end
  end
end
