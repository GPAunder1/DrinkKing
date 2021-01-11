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

    def fb_url
      @shop.menu.fb_url
    end

    def recommend_drink
      @shop.recommend_drink
    end

    def menu
      @shop.menu
    end

    def format_to_json
      shop_to_js = @shop.clone
      shop_to_js.fb_url = shop_to_js.menu.fb_url
      shop_to_js.menu = shop_to_js.menu.drinks

      openstruct_to_hash(shop_to_js).to_json
    end

    def openstruct_to_hash(object, hash = {})
      object.each_pair do |key, value|
        if value.is_a? OpenStruct
          hash[key] = openstruct_to_hash(value)
        elsif value.is_a? Array
          hash[key] = value.map { |v| openstruct_to_hash(v) }
        else
          value.gsub!('"', '“') if value.to_s.include? '"' # avoid javascript error
          hash[key] = value
        end
      end
      hash
    end
  end
end
