# frozen_string_literal: true

module Showoff
  class UsersClient < Base
    USERS_PATH = 'users'
    USERS_ME_PATH = 'users/me'
    USERS_EMAIL_PATH = 'users/email'
    USERS_ME_PASSWORD_PATH = 'users/me/password'
    USERS_RESET_PASSWORD_PATH = 'users/reset_password'

    def create(options = {})
      body = {
        user: {
          first_name: options[:first_name],
          last_name: options[:last_name],
          password: options[:password],
          email: options[:email],
          image_url: options[:image_url]
        }
      }
      response = perform_post_request(USERS_PATH, {}, body.compact)
      response_json = Oj.load(response.body, symbol_keys: true)
      @access_token = response_json[:data][:token][:access_token]
      response
    end

    def update(options = {})
      body = {
        user: {
          first_name: options[:first_name],
          last_name: options[:last_name],
          date_of_birth: options[:date_of_birth],
          image_url: options[:image_url]
        }
      }
      perform_put_request(USERS_ME_PATH, { authorization: "Bearer #{@access_token}" }, body.compact)
    end

    def show(id = nil)
      url = id.nil? ? USERS_ME_PATH : "#{USERS_PATH}/#{id}"
      perform_get_request(url)
    end

    def change_password(options = {})
      body = {
        user: {
          current_password: options[:current_password],
          new_password: options[:new_password]
        }
      }
      perform_post_request(USERS_ME_PASSWORD_PATH, {}, body.compact)
    end

    def check_email(options = {})
      body = {
        email: options[:email]
      }
      perform_get_request(USERS_EMAIL_PATH, {}, body.compact)
    end

    def reset_password(options = {})
      body = {
        user: {
          email: options[:email]
        }
      }
      perform_post_request(USERS_RESET_PASSWORD_PATH, {}, body.compact)
    end
  end
end
