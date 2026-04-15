# frozen_string_literal: true

require 'trello'

module TrelloZatsuPost
  class TrelloClient
    def initialize
      Trello.configure do |config|
        config.developer_public_key = ENV.fetch('TRELLO_DEVELOPER_PUBLIC_KEY')
        config.member_token = ENV.fetch('TRELLO_MEMBER_TOKEN')
      end
    end

    def create_card(name:, desc:)
      card = Trello::Card.create(
        name: name,
        desc: desc,
        list_id: ENV.fetch('TRELLO_LIST_ID')
      )

      card.url
    rescue Faraday::Error, Trello::Error => e
      warn "Error: Failed to communicate with Trello API: #{e.message}"
      exit 1
    end
  end
end
