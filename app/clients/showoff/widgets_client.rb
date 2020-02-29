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
        }
      }
      perform_post_request(WIDGETS_PATH, { authorization: "Bearer #{@access_token}" }, body.compact)
    end

    def update(id, options = {})
      body = {
        widget: {
          name: options[:name],
          description: options[:description]
        }
      }
      perform_put_request("#{WIDGETS_PATH}/#{id}", { authorization: "Bearer #{@access_token}" }, body.compact)
    end

    def show
      perform_get_request(WIDGETS_PATH, { authorization: "Bearer #{@access_token}" })
    end

    def destroy(id)
      perform_delete_request("#{WIDGETS_PATH}/#{id}", { authorization: "Bearer #{@access_token}" })
    end
  end
end
