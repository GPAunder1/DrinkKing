# frozen_string_literal: true

require 'roda'
require 'yaml'

module CodePraise
  # Configuration for the App
  class App < Roda
    CONFIG = YAML.safe_load(File.read('./config/secrets.yml'))
    TOKEN = CONFIG['api_token']
  end
end