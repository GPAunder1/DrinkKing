# frozen_string_literal: true

require_relative '../helpers/spec_helper.rb'

describe 'Unit test of DrinkKing API gateway' do
  it 'must report alive status' do
    alive = DrinkKing::Gateway::Api.new(DrinkKing::App.config).alive?
    _(alive).must_equal true
  end

  it 'must be able to add shops' do
    result = DrinkKing::Gateway::Api.new(DrinkKing::App.config)
      .add_shops(KEYWORD)

    _(result.success?).must_equal true
    # _(res.parse.keys.count).must_be :>=, 1
  end

  it 'must return a list of shops' do
    # GIVEN: a shop is in the database
    DrinkKing::Gateway::Api.new(DrinkKing::App.config).add_shops(KEYWORD)

    # WHEN: we request a list of shops
    # list = [[USERNAME, PROJECT_NAME].join('/')]
    result = DrinkKing::Gateway::Api.new(DrinkKing::App.config).list_shops(KEYWORD)

    # THEN: we should see shops in the list
    _(result.success?).must_equal true
    data = result.parse
    # _(data.keys).must_include 'projects'
    # _(data['projects'].count).must_equal 1
    # _(data['projects'].first.keys.count).must_be :>=, 5
  end

  it 'must return menu list' do
    # WHEN: we request shop menus
    result = DrinkKing::Gateway::Api.new(DrinkKing::App.config).get_menu(KEYWORD)

    # THEN: we should get shop menus
    _(result.sucess?).must_equal true
    data = result.parse
  end

  it 'must return recommend drink extraction' do
    # WHEN: we request drink extraction
    result = DrinkKing::Gateway::Api.new(DrinkKing::App.config).get_extraction(SHOPID)

    # THEN: we should get recommend drink
    _(result.sucess?).must_equal true
    data = result.parse
  end
end
