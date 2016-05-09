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

  test '#search_params should allow the expected search attributes' do
    params = ActionController::Parameters.new({"search"=>{"taco_ids"=>["4",""],
                                              "salsa_ids"=>["2","4","7","9",""],
                                              "foo" => ["bar", "baz"]}})
    filtered_params = StoresController::SearchParams.build(params)
    # also note the blank elements are removed thanks to `recursive_reject_blanks`
    assert_equal filtered_params, {"taco_ids"=>["4"],"salsa_ids"=>["2","4","7","9"]}
  end

  test 'POST /stores/search should process the search via Stores#search and return the results' do
    request_attributes = {"taco_ids"=>[],"salsa_ids"=>[]}

    mock_store_1 = MiniTest::Mock.new
    mock_store_1.expect(:name,"Foo 1"); mock_store_1.expect(:city,"City 1")

    mock_store_2 = MiniTest::Mock.new
    mock_store_2.expect(:name,"Foo 2"); mock_store_2.expect(:city,"City 2")

    mock = MiniTest::Mock.new
    mock.expect(:call, [mock_store_1, mock_store_2], [request_attributes])
    Store.stub(:search, mock) do
      post :search, {"search" => request_attributes.merge({"foo" => ["bar", "baz"]})}
    end
    assert_response :success
    mock.verify
    assert_select 'table.results'
    assert_select 'table.results tr', 3 # 1 for the header, and 2 for the results
    assert_select 'td', "City 1"

  end
  test 'POST /stores/search should handle no results' do
    request_attributes = {"taco_ids"=>[],"salsa_ids"=>[]}
    mock = MiniTest::Mock.new
    mock.expect(:call, [], [request_attributes])
    Store.stub(:search, mock) do
      post :search, {"search" => request_attributes.merge({"foo" => ["bar", "baz"]})}
    end
    assert_response :success
    mock.verify
    assert_select 'table.results', false, "Search with no results should not have a table"

  end
  test "POST /stores/search [no mocks]" do
    search_params = {"taco_ids"=>[tacos(:carne_asada).id, tacos(:pescado).id].flatten,
          "salsa_ids"=>[salsas(:habenero).id, salsas(:pico_de_gallo).id].flatten}
    post :search, {"search" => search_params}

    assert_response :success
    assert_select 'table.results'
    assert_select 'td', "Robertos"
  end

  test "POST /stores/search [no mocks, just tacos]" do
    search_params = {"taco_ids"=>[tacos(:carne_asada).id, tacos(:pescado).id].flatten,
          "salsa_ids"=>[]}
    post :search, {"search" => search_params}

    assert_response :success
    assert_select 'table.results'
    assert_select 'td', "Robertos"
  end


end
