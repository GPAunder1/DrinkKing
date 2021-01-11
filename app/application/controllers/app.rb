# frozen_string_literal: true

require 'roda'
require 'slim/include'

module DrinkKing
  # The class is responible for routing the url
  class App < Roda
    plugin :flash
    plugin :all_verbs # allows DELETE and other HTTP verbs beyond GET/POST
    plugin :render, engine: 'slim', views: 'app/presentation/views_html/'
    plugin :assets, path: 'app/presentation/assets/',
                    css: 'style.css', js: ['location.js', 'map.js', 'shop.js', 'main.js']
    plugin :halt
    plugin :unescape_path # decodes a URL-encoded path before routing

    use Rack::MethodOverride # for other HTTP verbs (with plugin all_verbs)

    opts[:root] = 'app/presentation/assets/'
    plugin :public, root: 'img'

    route do |routing|
      routing.assets
      routing.public

      # GET /
      routing.root do
        # Get visitor's search_word
        # session[:search_word].clear
        session[:search_word] ||= []
        promotions_one_free = Service::Promotion.new.call({ keyword: 'one_free' })
        display_promotions_one_free = Views::ShopsPage.new(promotions_one_free.value!)

        promotions_new_drink = Service::Promotion.new.call({ keyword: 'new_drink' })
        display_promotions_new_drink = Views::ShopsPage.new(promotions_new_drink.value!)

        view 'index', locals: { records: session[:search_word], promotions_one_free: display_promotions_one_free\
                              , promotions_new_drink: display_promotions_new_drink }
      end

      routing.on 'shop' do
        routing.is do
          # POST /shop/
          routing.post do
            search_word = routing.params['drinking_shop']
            latitude = routing.params['latitude']
            longitude = routing.params['longitude']

            shops_made = Service::AddShops.new.call(
                                                    search_keyword: search_word,
                                                    latitude: latitude,
                                                    longitude: longitude
                                                   )

            if shops_made.failure?
              flash[:error] = shops_made.failure
              routing.redirect '/'
            end

            session[:search_word].insert(0, search_word).uniq!
            # Redirect to search result page
            routing.redirect "shop/#{search_word}"
          end
        end

        routing.on String do |search_word|
          # GET /shop/{search_word}
          routing.get do
            result = Service::ListShops.new.call(search_keyword: search_word)
            if result.failure?
              flash[:error] = result.failure
              routing.redirect '/'
            end

            result = result.value!
            if result['response'].processing?
              # flash[:notice] = result['response'].message.to_s # request_id
              # routing.redirect '/' # comment when done
            else
              shops = result['shops'].shops
              display_shops = Views::ShopsList.new(shops)
            end

            processing = Views::ExtractionProcessing.new(
              App.config, result['response']
            )

            view 'shop', locals: { shops: display_shops, processing: processing, search_keyword: search_word}
          end
        end
      end

      routing.on 'test' do
        shops = Repository::For.klass(Entity::Shop).all
        view 'test', locals: { shops: shops }
      end
    end
  end
end
