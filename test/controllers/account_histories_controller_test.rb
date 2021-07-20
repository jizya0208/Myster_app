require 'test_helper'

class AccountHistoriesControllerTest < ActionDispatch::IntegrationTest
  test 'should get new' do
    get account_histories_new_url
    assert_response :success
  end

  test 'should get index' do
    get account_histories_index_url
    assert_response :success
  end
end
