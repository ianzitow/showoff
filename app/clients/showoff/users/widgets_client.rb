# frozen_string_literal: true

module Showoff
  module Users
    class WidgetsClient < Base
      USERS_ME_WIDGETS_PATH = 'api/v1/users/me/widgets'
      USERS_PATH = 'api/v1/users'

      def show(id = nil, term = nil)
        url = id.nil? ? USERS_ME_WIDGETS_PATH : "#{USERS_PATH}/#{id}/widgets"
        body = { term: term }
        perform_get_request(url, { authorization: "Bearer #{@access_token}" }, body.compact)
      end
    end
  end
end