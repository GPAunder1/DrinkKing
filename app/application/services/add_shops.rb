# frozen_string_literal: true

require 'dry/transaction'

module DrinkKing
  module Service
    # Transaction to store shop from Googlemap Place API to database
    class AddShops
      include Dry::Transaction

      step :api_add_shoplist
      step :decorate_shoplist
      step :reify_list

      private

      def api_add_shoplist(input)
        DrinkKing::Gateway::Api.new(App.config).add_shops(input[:search_keyword], input[:latitude], input[:longitude])
            .then do |result|
              result.success? ? Success(result.payload) : Failure(result.message)
            end
      rescue StandardError
        Failure('Cannot search shops right now; please try again later')
      end

      def decorate_shoplist(input)
        input = JSON.parse(input)
        input['shops'].map do |shop|
          shop['recommend_drink'] = nil
          shop['menu'] = nil
        end
        Success(input.to_json)
      end

      def reify_list(shoplist_json)
        Representer::ShopsList.new(OpenStruct.new)
                              .from_json(shoplist_json)
                              .then { |shop| Success(shop) }
      rescue StandardError => e
        puts e.to_s
        Failure('Error in the project -- please try again')
      end
    end
  end
end
