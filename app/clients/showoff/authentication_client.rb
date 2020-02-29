# frozen_string_literal: true

module Showoff
  class AuthenticationClient < Base
    OAUTH_TOKEN_PATH = 'oauth/token'
    OAUTH_REVOKE_PATH = 'oauth/revoke'

    def create(options = {})
      body = {
        grant_type: 'password',
        username: options[:username],
        password: options[:password]
      }
      response = perform_post_request(OAUTH_TOKEN_PATH, {}, body.compact)
      response_json = Oj.load(response.body, symbol_keys: true)
      @access_token = response_json[:data][:token][:access_token]
      @refresh_token = response_json[:data][:token][:refresh_token]
      response
    end

    def revoke
      body = {
        token: @access_token
      }
      perform_post_request(OAUTH_REVOKE_PATH, { authorization: "Bearer #{@access_token}" }, body.compact)
    end

    def refresh
      body = {
        grant_type: 'refresh_token',
        refresh_token: @refresh_token
      }
      perform_post_request(OAUTH_TOKEN_PATH, { authorization: "Bearer #{@access_token}" }, body.compact)
    end
  end
end
