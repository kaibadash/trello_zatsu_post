# frozen_string_literal: true

module TrelloZatsuPost
  class Cli
    REQUIRED_ENV_VARS = %w[
      LLM_ACCESS_TOKEN
      TRELLO_DEVELOPER_PUBLIC_KEY
      TRELLO_MEMBER_TOKEN
      TRELLO_LIST_ID
    ].freeze

    def initialize(argv)
      @argv = argv
    end

    def run
      validate_env_vars!
      message = validate_message!

      generated = AiGenerator.new.generate(message)
      card_url = TrelloClient.new.create_card(
        name: generated[:title],
        desc: generated[:description]
      )

      puts "Card created: #{card_url}"
    end

    private

    def validate_message!
      message = @argv.first
      if message.nil? || message.strip.empty?
        warn 'Error: Please provide a message'
        warn 'Usage: bundle exec ruby bin/trello_post <message>'
        exit 1
      end
      message
    end

    def validate_env_vars!
      REQUIRED_ENV_VARS.each do |var|
        if ENV[var].nil? || ENV[var].strip.empty?
          warn "Error: Environment variable #{var} is not set"
          exit 1
        end
      end
    end
  end
end
