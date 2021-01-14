# frozen_string_literal: true

require_relative '../helpers/spec_helper.rb'

describe 'ListShops Service and API gateway Integration Test' do

  it 'must return a list of shops' do
    # GIVEN: a shop is in the database
    DrinkKing::Gateway::Api.new(DrinkKing::App.config).add_shops(KEYWORD, LATITUDE, LONGITUDE)

    # WHEN: we request to get list of shops
    result = DrinkKing::Service::ListShops.new.call(search_keyword: KEYWORD)

    # THEN: we should see shops in the list
    _(result.success?).must_equal true

    shop = result.value!['shops'].shops[0]
    _(shop.name).must_equal KEYWORD
    _(shop.name).must_include shop.menu.shopname
  end

  # it '(BAD) should report error if no shop is found' do
  #   # WHEN: user goes to the shop map page that has no shop found
  #   shops_made = DrinkKing::Service::ListShops.new.call(search_keyword: GARBLE)
  #
  #   # THEN: they should get error messege
  #   _(shops_made.failure).must_equal 'No shop is found!'
  # end
end
