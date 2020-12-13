# frozen_string_literal: true

require 'dry/transaction'

module DrinkKing
  module Service
    # Transaction to process shops(extract shop reviews to get recommend drink, get menu)
    class ListShops
      include Dry::Transaction

      step :api_shoplist
      step :decorate_shoplist
      step :reify_list

      private

      def api_shoplist(input)
        DrinkKing::Gateway::Api.new(App.config).list_shops(input[:search_keyword])
          .then do |result|
            result.success? ? Success(JSON.parse(result.body)) : Failure(result.message)
          end

        # shops.map { |shop| puts shop }
      end

      def decorate_shoplist(input)
        input['shops'].map do |shop|
          drink = DrinkKing::Gateway::Api.new(App.config).recommend_drink(shop['placeid'])
          menu = DrinkKing::Gateway::Api.new(App.config).shop_menu(shop['name'])
          shop['recommend_drink'] = JSON.parse(drink.payload)
          shop['menu'] = JSON.parse(menu.payload)[0]
        end
        Success(input.to_json)
      end

      def reify_list(shoplist_json)
        Representer::ShopsList.new(OpenStruct.new)
                              .from_json(shoplist_json)
                              .then { |shop| Success(shop) }
      rescue StandardError => e
        # puts e.to_s
        Failure('Error in list shops -- please try again')
      end
    end
  end
end
