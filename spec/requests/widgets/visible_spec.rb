# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Widgets/Visible', type: :request do
  let(:visible_sentence) { FFaker::Lorem.sentence(3) }
  let(:response_visible) do
    @widgets_client.create(
      name: visible_sentence,
      description: FFaker::Lorem.paragraph(2),
      kind: 'visible'
    )
  end
  let(:response_visible_json) { Oj.load(response_visible, symbol_keys: true) }
  let(:widget_id) { response_visible_json[:data][:widget][:id] }

  before(:all) do
    authentication_client = Showoff::AuthenticationClient.new
    authentication_client.create(
      username: 'mike@showoff.ie',
      password: 'password'
    )
    @widgets_client = Showoff::WidgetsClient.new(authentication_client.access_token, authentication_client.refresh_token)
    @widgets_visible_client = Showoff::Widgets::VisibleClient.new(authentication_client.access_token, authentication_client.refresh_token)
  end

  describe 'GET /widgets/visible' do
    it 'shows visible widgets' do
      expect(response_visible.code).to eq(200)
      response = @widgets_visible_client.show
      expect(response.code).to eq(200)
      response_json = Oj.load(response.body, symbol_keys: true)
      kinds = response_json[:data][:widgets].pluck(:kind)
      expect(kinds).to all(eq('visible'))
    end

    it 'shows only visible widgets with a term' do
      response = @widgets_visible_client.show(visible_sentence.split[-2])
      expect(response.code).to eq(200)
      response_json = Oj.load(response.body, symbol_keys: true)
      expect(response_json[:data][:widgets].count).to be > 0
    end
  end
end
