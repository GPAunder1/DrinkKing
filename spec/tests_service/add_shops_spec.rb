# frozen_string_literal: true

require_relative '../helpers/spec_helper.rb'

describe 'AddShops Service and API gateway integration Test' do
  it 'must add a shop' do
    # WHEN: we request to add shop to database
    keyword_request = DrinkKing::Forms::SearchKeyword.new.call(search_keyword: KEYWORD)

    result = DrinkKing::Service::AddShops.new.call(keyword_request)

    # THEN: we should see shop lists
    _(result.success?).must_equal true
    shops = result.value!
    # _(shops[0].shopname).must_equal KEYWORD # 不知道目前會輸出啥 先盲寫
  end

  # it '(BAD) should fail for invalid search keyword' do
  #   # GIVEN: a valid search keyword to find shops
  #   keyword_request = DrinkKing::Forms::SearchKeyword.new.call(search_keyword: GARBLE)
  #
  #   # WHEN: the service is called with the request form object
  #   shops_made = DrinkKing::Service::AddShops.new.call(keyword_request)
  #
  #   # THEN: the result should be failure and get error message
  #   _(shops_made.success?).must_equal false
  #   _(shops_made.failure).must_equal 'Please enter keyword related to drink'
  # end
end
