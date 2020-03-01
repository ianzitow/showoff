# frozen_string_literal: true

module Showoff
  module Widgets
    class VisibleClient < Base
      WIDGETS_VISIBLE_PATH = 'api/v1/widgets/visible'

      def show(term = nil)
        body = { term: term }
        perform_get_request(WIDGETS_VISIBLE_PATH, { authorization: "Bearer #{@access_token}" }, body.compact)
      end
    end
  end
end