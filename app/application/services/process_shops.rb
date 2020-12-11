# frozen_string_literal: true

require 'dry/transaction'

module DrinkKing
  module Service
    # Transaction to process shops(extract shop reviews to get recommend drink, get menu)
    class ProcessShops
      include Dry::Transaction

      step :api_shoplist
      step :reify_list

      private

      def api_shoplist(input)
        DrinkKing::Gateway::Api.new(App.config).list_shops(input[:search_keyword])
          .then do |result|
            result.success? ? Success(result.payload) : Failure(result.message)
          end
      end

      def reify_list(shoplist_json)
        Success(Representer::ShopsList.new(shoplist_json).to_json)
      rescue StandardError
        Failure('Could not parse response from API')
      end
    end
  end
end
