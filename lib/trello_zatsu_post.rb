# frozen_string_literal: true

require 'dotenv'
Dotenv.load(File.expand_path('../.env', __dir__))
require_relative 'trello_zatsu_post/cli'
require_relative 'trello_zatsu_post/ai_generator'
require_relative 'trello_zatsu_post/trello_client'
