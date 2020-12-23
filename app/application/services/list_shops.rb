# frozen_string_literal: true

require 'dry/transaction'

module DrinkKing
  module Service
    # Transaction to process shops(extract shop reviews to get recommend drink, get menu)
    class ListShops
      include Dry::Transaction

      step :get_api_shoplist
      step :get_api_menu
      step :get_api_extraction
      step :reify_list

      private

      def get_api_shoplist(input)
        DrinkKing::Gateway::Api.new(App.config).list_shops(input[:search_keyword])
          .then do |result|
            result.success? ? Success(JSON.parse(result.body)) : Failure(result.message)
          end

        # shops.map { |shop| puts shop }
      end

      def get_api_menu(input)
        input['shops'].map do |shop|
          menu = DrinkKing::Gateway::Api.new(App.config).shop_menu(shop['name'])
          shop['menu'] = JSON.parse(menu.payload)[0]
        end
        Success(input)
      end

      def get_api_extraction(input)
        input['shops'].map do |shop|
          result = DrinkKing::Gateway::Api.new(App.config).recommend_drink(shop['placeid'])
          return Failure(result.message) if result.failure?

          input['response'] = result
          return Success(input) if result.processing?

          shop['recommend_drink'] = JSON.parse(result.payload)
        end

        Success(input)
      rescue StandardError
        Failure('Cannot get recommend drink right now; please try again later')
      end

      def reify_list(input)
        unless input['response'].processing?
          Representer::ShopsList.new(OpenStruct.new)
                                .from_json(input.to_json)
                                .then { input['shops'] = _1 }
        end

        Success(input)
      rescue StandardError => e
        # puts e.to_s
        Failure('Error in list shops -- please try again')
      end
    end
  end
end
