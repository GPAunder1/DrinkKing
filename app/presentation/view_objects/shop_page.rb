# frozen_string_literal: true

module Views
  # View for shop and shop extractions(recommend drink, menu) for a given shop
  class ShopPage
    def initialize(shop_page)
      @shop_page = shop_page
    end

    def shopname
      @shop_page.shopname
    end

    def posts
      @shop_page.posts.map { |post| Post.new(post)}
    end

    def posts_each
      @shop_page.posts.each do |post|
        yield post
      end
    end
  end
end
