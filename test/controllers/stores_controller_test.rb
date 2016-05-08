require 'test_helper'
require 'minitest/mock'

class StoresControllerTest < ActionController::TestCase
  test "GET /stores/search should have the store search form" do
    assert_routing({ method: 'get', path: '/stores/search' }, {controller: 'stores', action: 'search_form'})
    get :search_form
    assert_response :success
    assert_template :search_form
    assert_select 'form#stores-search-form'
  end

end
