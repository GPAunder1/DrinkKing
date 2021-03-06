# frozen_string_literal: true

require 'http'

module DrinkKing
  module Gateway
    # Api
    class Api
      def initialize(config)
        @config = config
        @request = Request.new(@config)
      end

      def alive?
        @request.get_root.success?
      end

      def list_shops(shopname)
        @request.list_shops(shopname)
      end

      def add_shops(shopname, latitude, longitude)
        @request.add_shops(shopname, latitude, longitude)
      end

      def recommend_drink(shop_id)
        @request.recommend_drink(shop_id)
      end

      def shop_menu(shopname)
        @request.shop_menu(shopname)
      end

      def get_promotion(keyword)
        @request.get_promotion(keyword)
      end
      # HTTP request transmitter
      class Request
        def initialize(config)
          @api_host = config.API_HOST
          @api_root = config.API_HOST + '/api/v1'
        end

        def get_root # rubocop:disable Naming/AccessorMethodName
          call_api('get')
        end

        def list_shops(shopname)
          call_api('get', ['shops'], { 'keyword' => shopname })
        end

        def add_shops(shopname, latitude, longitude)
          call_api('post', ['shops', shopname], { 'latitude' => latitude, 'longitude'=> longitude })
        end

        def recommend_drink(shop_id)
          call_api('get', ['extractions', shop_id])
        end

        def shop_menu(shopname)
          call_api('get', ['menus'], { 'keyword' => shopname, 'searchby' => 'shop' })
        end

        def get_promotion(keyword)
          call_api('get', ['promotion'], {'keyword' => keyword } )
        end
        private

        def params_str(params)
          params.map { |key, value| "#{key}=#{CGI.escape(value)}" }.join('&')
            .then { |str| str ? '?' + str : '' }
        end

        def call_api(method, resources = [], params = {})
          api_path = resources.empty? ? @api_host : @api_root
          url = [api_path, resources].join('/') + params_str(params)
          puts "url:#{CGI.unescape(url)}"
          HTTP.headers('Accept' => 'application/json').send(method, url)
          .then { |http_response| Response.new(http_response) }
        rescue StandardError
          raise "Invalid URL request: #{url}"
        end
      end

      # Decorates HTTP responses with success/error
      class Response < SimpleDelegator
        NotFound = Class.new(StandardError)

        SUCCESS_CODES = (200..299).freeze

        def success?
          code.between?(SUCCESS_CODES.first, SUCCESS_CODES.last)
        end

        def failure?
          !success?
        end

        def ok?
          code == 200
        end

        def added?
          code == 201
        end

        def processing?
          code == 202
        end

        def message
          JSON.parse(payload)['message']
        end

        def payload
          body.to_s
        end
      end
    end
  end
end
