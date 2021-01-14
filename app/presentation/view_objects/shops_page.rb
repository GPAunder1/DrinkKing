# frozen_string_literal: true

module Views
  # View for shop_lists
  class ShopsPage
    def initialize(shops_page)
      @shops_page = shops_page.map { |shop_page| ShopPage.new(shop_page) }
    end

    def each
      @shops_page.each do |shop_page|
        yield shop_page
      end
    end
  end
end
