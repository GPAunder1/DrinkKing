# frozen_string_literal: true

module Views
  # View for shop and shop extractions(recommend drink, menu) for a given shop
  class Shop
    def initialize(shop)
      @shop = shop
    end

    def entity
      @shop
    end

    def name
      @shop.name
    end

    def address
      @shop.address
    end

    def latitude
      @shop.latitude
    end

    def longitude
      @shop.longitude
    end

    def phone_number
      @shop.phone_number
    end

    def map_url
      @shop.map_url
    end

    def opening_now
      @shop.opening_now
    end

    def rating
      @shop.rating
    end

    def reviews
      @shop.reviews.map { |review| Review.new(review) }
    end

    def recommend_drink
      @shop.recommend_drink
    end

    def menu
      @shop.menu.drinks
    end

    def format_to_json
      @shop.menu = @shop.menu.drinks
      openstruct_to_hash(@shop).to_json
    end

    def openstruct_to_hash(object, hash = {})
      object.each_pair do |key, value|
        if value.is_a? OpenStruct
          hash[key] = openstruct_to_hash(value)
        elsif value.is_a? Array
          hash[key] = value.map { |v| openstruct_to_hash(v) }
        else
          hash[key] = value
        end
      end
      hash
    end
  end
end
