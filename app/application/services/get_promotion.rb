require 'dry/transaction'

module DrinkKing
  module Service
    # Transaction to store shop from Googlemap Place API to database
    class Promotion
      include Dry::Transaction
      step :get_promotion
      step :reify_list

      def get_promotion
        DrinkKing::Gateway::Api.new(App.config).get_promotion
          .then do |result|
            result.success? ? Success(JSON.parse(result.body)) : Failure(result.message)
          end
      end

      def reify_list(promotion_json)
        Representer::ShopsPage.new(OpenStruct.new)
                              .from_json(promotion_json.to_json)
                              .then { |promotion| Success(promotion.shops_page) }
      rescue StandardError => e
        puts e.to_s
        Failure('Error in the project -- please try again')
      end
    end
  end
end
