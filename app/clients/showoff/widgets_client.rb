# frozen_string_literal: true

module Showoff
  class WidgetsClient < Base
    WIDGETS_PATH = 'api/v1/widgets'

    def create(options = {})
      body = {
        widget: {
          name: options[:name],
          description: options[:description],
          kind: options[:kind]
        }.compact
      }
      perform_post_request(WIDGETS_PATH, { authorization: "Bearer #{@access_token}" }, body)
    end

    def update(id, options = {})
      body = {
        widget: {
          name: options[:name],
          description: options[:description]
        }.compact
      }
      perform_put_request("#{WIDGETS_PATH}/#{id}", { authorization: "Bearer #{@access_token}" }, body)
    end

    def show
      perform_get_request(WIDGETS_PATH, { authorization: "Bearer #{@access_token}" })
    end

    def destroy(id)
      perform_delete_request("#{WIDGETS_PATH}/#{id}", { authorization: "Bearer #{@access_token}" })
    end
  end
end
