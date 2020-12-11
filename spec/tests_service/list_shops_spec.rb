# frozen_string_literal: true

require_relative '../helpers/spec_helper.rb'

describe 'ListShops Service and API gateway Integration Test' do

  it 'must return a list of shops' do
    # GIVEN: a shop is in the database
    DrinkKing::Gateway::Api.new(DrinkKing::App.config).add_shops(KEYWORD)

    # WHEN: we request to get list of shops
    result = DrinkKing::Service::ProcessShops.new.call(search_keyword: KEYWORD)

    # THEN: we should see shops in the list
    _(result.success?).must_equal true
    shops = result.value!
    # _(shops[0].shopname).must_equal KEYWORD # 不知道目前會輸出啥 先盲寫

    # THEN: should get shops with recommend drink and menu
    # _(shops.has_key?(:shops)).must_equal true
    # _(shops.has_key?(:recommend_drinks)).must_equal true
    # _(shops.has_key?(:menu)).must_equal true
  end

  # it '(BAD) should report error if no shop is found' do
  #   # WHEN: user goes to the shop map page that has no shop found
  #   shops_made = DrinkKing::Service::ProcessShops.new.call(search_keyword: GARBLE)
  #
  #   # THEN: they should get error messege
  #   _(shops_made.failure).must_equal 'No shop is found!'
  # end
end
