# frozen_string_literal: true

require 'openai'
require 'json'
require 'erb'

module TrelloZatsuPost
  class AiGenerator
    DEFAULT_MODEL = 'gpt-4o-mini'
    PROJECT_ROOT = File.expand_path('../..', __dir__)
    PROMPT_DIR = File.join(PROJECT_ROOT, 'prompts')
    DEFAULT_PROMPT_FILE = File.join(PROMPT_DIR, 'system.erb')

    def initialize
      @client = OpenAI::Client.new(build_config)
      @model = ENV.fetch('LLM_MODEL', DEFAULT_MODEL)
    end

    def generate(message)
      response = @client.chat(
        parameters: {
          model: @model,
          response_format: { type: 'json_object' },
          messages: [
            { role: 'system', content: render_system_prompt(message: message, language: ENV['LANGUAGE']) },
            { role: 'user', content: message }
          ]
        }
      )

      if response.is_a?(Hash) && response['error']
        warn "Error: AI API returned an error: #{response['error']}"
        exit 1
      end

      content = response.dig('choices', 0, 'message', 'content')
      parsed = JSON.parse(content, symbolize_names: true)

      { title: parsed[:title], description: parsed[:description] }
    rescue Faraday::Error => e
      body = e.response&.dig(:body) if e.respond_to?(:response)
      warn "Error: Failed to communicate with AI API: #{e.message}"
      warn "Response body: #{body}" if body
      exit 1
    rescue JSON::ParserError => e
      warn "Error: Failed to parse AI API response: #{e.message}"
      exit 1
    end

    private

    def build_config
      config = {}
      config[:access_token] = ENV['LLM_ACCESS_TOKEN'] if ENV['LLM_ACCESS_TOKEN']
      config[:uri_base] = ENV['LLM_URI_BASE'] if ENV['LLM_URI_BASE']
      config
    end

    def render_system_prompt(**locals)
      path = ENV.fetch('LLM_SYSTEM_PROMPT', DEFAULT_PROMPT_FILE)
      path = File.expand_path(path, PROJECT_ROOT) unless File.absolute_path?(path)
      template = File.read(path)
      ERB.new(template, trim_mode: '-').result_with_hash(locals)
    end
  end
end
