# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require 'vcr'
require 'webmock'
require_relative '../init'

GARBLE = 'dcnisndisncsdc'
BAD_TOKEN = 'snidnsicndsivndsivdsv'
KEYWORD = '可不可'
TOKEN = CodePraise::App.config.API_TOKEN
CORRECT = YAML.safe_load(File.read('spec/fixtures/googlemap_results.yml'))
