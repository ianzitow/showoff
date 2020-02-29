module Showoff
  class Base
    CLIENT_ID = Rails.application.credentials.showoff[:client_id].freeze
    CLIENT_SECRET = Rails.application.credentials.showoff[:client_secret].freeze
    BASE_URL = 'https://showoff-rails-react-production.herokuapp.com'.freeze

    attr_reader :access_token, :refresh_token

    def initialize(access_token = nil, refresh_token = nil)
      @access_token = access_token
      @refresh_token = refresh_token
    end

    %i[get post put delete].each do |method|
      define_method("perform_#{method}_request") do |path, headers = {}, payload = {}|
        payload[:client_id] = CLIENT_ID
        payload[:client_secret] = CLIENT_SECRET
        headers[:content_type] = :json
        headers[:accept] = :json
        RestClient::Request.execute(
          method: method,
          url: "#{BASE_URL}/#{path}",
          payload: payload.to_json,
          headers: headers
        )
      end
    end
  end
end