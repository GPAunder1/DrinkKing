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
                    css: 'style.css', js: ['map.js', 'shop.js']
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
        # session[:search_word] ||= []
        alive = DrinkKing::Gateway::Api.new(DrinkKing::App.config).alive?

        puts alive

        # different kind of shop names(ex:可不可, 鮮茶道)
        # if result.failure?
        #   flash[:error] = result.failure
        # else
        #   shops = result.value!
        #   display_shops = Views::ShopsList.new(shops)
        # end
        # view 'index', locals: { shops: display_shops, records: session[:search_word] }
      end

      routing.on 'shop' do
        routing.is do
          # POST /shop/
          routing.post do
            search_word = routing.params['drinking_shop']
            shops_made = Service::AddShops.new.call(search_keyword: '可不可熟成紅茶')
            puts shops_made
            # session[:search_word].insert(0, search_word).uniq!
            # Redirect to search result page
            # routing.redirect "shop/#{search_word}"
          end
        end

        routing.on String do |search_word|
          # GET /shop/{search_word}
          routing.get do
            result = DrinkKing::Service::ListShops.new.call(search_keyword: search_word)
            puts "-----------#{result.value!}"
            # if result.failure?
            #   flash[:error] = result.failure
            #   routing.redirect '/'
            # else
            #   shops = result.value!
            #
            #   display_shops = Views::ShopsList.new(shops[:shops], shops[:recommend_drinks], shops[:menu])
            # end


            # view 'shop', locals: { shops: display_shops }
            # view 'shop', locals: { shops: shops , recommend_drinks: recommend_drinks, menu: menu}
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
