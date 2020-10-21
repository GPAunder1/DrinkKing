# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/googlemap_api'
require 'vcr'
require 'webmock'

GARBLE = 'dcnisndisncsdc'
BAD_TOKEN = 'snidnsicndsivndsivdsv'
TOKEN = YAML.safe_load(File.read('config/secrets.yml'))['api_token']
CORRECT = YAML.safe_load(File.read('spec/fixtures/googlemap_results.yml'))

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'googlemap_api'