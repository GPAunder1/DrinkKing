# frozen_string_literal: true

module Views
  # View for shop_lists
  class ShopsList
    def initialize(shops)
      @shops = shops.map { |shop| Shop.new(shop) }
    end

    def each
      @shops.each do |shop|
        yield shop
      end
    end
  end
end
