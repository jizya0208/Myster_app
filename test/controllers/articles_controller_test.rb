require 'test_helper'

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  test 'should get confirm' do
    get articles_confirm_url
    assert_response :success
  end

  test 'should get index' do
    get articles_index_url
    assert_response :success
  end

  test 'should get new' do
    get articles_new_url
    assert_response :success
  end

  test 'should get show' do
    get articles_show_url
    assert_response :success
  end
end
