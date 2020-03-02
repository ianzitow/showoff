# frozen_string_literal: true

module Showoff
  class UsersClient < Base
    USERS_PATH = 'api/v1/users'
    USERS_ME_PATH = 'api/v1/users/me'
    USERS_EMAIL_PATH = 'api/v1/users/email'
    USERS_ME_PASSWORD_PATH = 'api/v1/users/me/password'
    USERS_RESET_PASSWORD_PATH = 'api/v1/users/reset_password'

    def create(options = {})
      body = {
        user: {
          first_name: options[:first_name],
          last_name: options[:last_name],
          password: options[:password],
          email: options[:email],
          image_url: options[:image_url]
        }.compact
      }
      response = perform_post_request(USERS_PATH, {}, body)
      response_json = Oj.load(response.body, symbol_keys: true)
      @access_token = response_json[:data][:token][:access_token]
      @refresh_token = response_json[:data][:token][:refresh_token]
      response
    end

    def update(options = {})
      body = {
        user: {
          first_name: options[:first_name],
          last_name: options[:last_name],
          date_of_birth: options[:date_of_birth],
          image_url: options[:image_url]
        }.compact
      }
      perform_put_request(USERS_ME_PATH, { authorization: "Bearer #{@access_token}" }, body)
    end

    def show(id = nil)
      url = id.nil? ? USERS_ME_PATH : "#{USERS_PATH}/#{id}"
      perform_get_request(url, { authorization: "Bearer #{@access_token}" })
    end

    def change_password(options = {})
      body = {
        user: {
          current_password: options[:current_password],
          new_password: options[:new_password]
        }.compact
      }
      perform_post_request(USERS_ME_PASSWORD_PATH, { authorization: "Bearer #{@access_token}" }, body)
    end

    def check_email(options = {})
      body = {
        email: options[:email]
      }.compact
      perform_get_request(USERS_EMAIL_PATH, {}, body)
    end

    def reset_password(options = {})
      body = {
        user: {
          email: options[:email]
        }.compact
      }
      perform_post_request(USERS_RESET_PASSWORD_PATH, {}, body)
    end
  end
end
