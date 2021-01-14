# frozen_string_literal: true

require_relative '../helpers/spec_helper'

describe 'Unit test of DrinkKing API gateway' do
  it 'must report alive status' do
    alive = DrinkKing::Gateway::Api.new(DrinkKing::App.config).alive?
    _(alive).must_equal true
  end

  it 'must be able to add shops' do
    result = DrinkKing::Gateway::Api.new(DrinkKing::App.config)
                                    .add_shops(KEYWORD, LATITUDE, LONGITUDE)

    _(result.success?).must_equal true
    _(result.parse.keys.count).must_be :>=, 1
  end

  it 'must return a list of shops' do
    # GIVEN: a shop is in the database
    DrinkKing::Gateway::Api.new(DrinkKing::App.config).add_shops(KEYWORD, LATITUDE, LONGITUDE)

    # WHEN: we request a list of shops
    result = DrinkKing::Gateway::Api.new(DrinkKing::App.config).list_shops(KEYWORD)

    # THEN: we should see shops in the list
    _(result.success?).must_equal true

    shop = result.parse['shops'][0]
    _(shop['name']).must_equal KEYWORD
    _(shop['reviews'].count).must_be :<=, 5
  end

  it 'must return menu list' do
    # WHEN: we request shop menus
    result = DrinkKing::Gateway::Api.new(DrinkKing::App.config).shop_menu(KEYWORD)

    # THEN: we should get shop menus
    _(result.success?).must_equal true

    data = result.parse[0]
    _(data['shopname']).must_include KEYWORD
  end

  it 'must return recommend drink extraction' do
    # WHEN: we request drink extraction
    result = DrinkKing::Gateway::Api.new(DrinkKing::App.config).recommend_drink(SHOPID)

    # THEN: we should get recommend drink
    _(result.success?).must_equal true

    data = result.parse
    _(data['message']).must_equal RECOMMEND_DRINK
  end
end
