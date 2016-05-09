require 'test_helper'

class StoreTest < ActiveSupport::TestCase
  # This feels a bit like testing syntax which is usually a waste of time, but
  # it is a good sanity check for now. Eventually, this would be replacing by implicit
  # tests around the association
  test 'HABTM ~> tacos' do
    tacos = Store.reflect_on_association(:tacos)
    assert_equal tacos.macro, :has_and_belongs_to_many
  end
  test 'HABTM ~> salsas' do
    salsas = Store.reflect_on_association(:salsas)
    assert_equal salsas.macro, :has_and_belongs_to_many
  end

  ## Implicitly test StoresTacos#store_id_with_all_taco_types(taco_type_ids[])
  test 'scope#with_all_taco_types' do
    # fixtures
    ids = [tacos(:carne_asada).id, tacos(:pescado).id].flatten

    stores = Store.with_all_taco_types(ids)

    assert_equal ["El Matador","Robertos"], stores.map(&:name).sort
  end

  ## Implicitly test StoresSalsa#store_id_with_all_salsa_types(salsa_type_ids[])
  test 'scope#with_all_salsa_types' do
    # fixtures
    ids = [salsas(:habenero).id, salsas(:pico_de_gallo).id].flatten

    stores = Store.with_all_salsa_types(ids)

    assert_equal ["Robertos"], stores.map(&:name)
  end


  # REVIEW: what if param isn't passed in?, e.g #search {"taco_ids"=>[5,10]}
  test '#search should call each of the scopes' do
    search_params = {"taco_ids"=>[5,10],"salsa_ids"=>[10,5]}

    taco_mock =  MiniTest::Mock.new
    taco_mock.expect(:call, [], [[5,10]])
    salsa_mock =  MiniTest::Mock.new
    salsa_mock.expect(:call, [], [[10,5]])

    # Minitest mocking leaves a bit to be desired when mocking multiple calls in
    # a single test.
    Store.stub(:with_all_taco_types, taco_mock) do
      Store.stub(:with_all_salsa_types, salsa_mock) do
        Store.search search_params
      end
    end
    taco_mock.verify
    salsa_mock.verify
  end

  test '#search with no results' do
    search_params = {"taco_ids"=>[5,10],"salsa_ids"=>[10,5]}

    results = Store.search(search_params)

    assert_equal Store.none, results
  end

  test '#search with results' do
    search_params = {"taco_ids"=>[tacos(:carne_asada).id, tacos(:pescado).id].flatten,
          "salsa_ids"=>[salsas(:habenero).id, salsas(:pico_de_gallo).id].flatten}

    results = Store.search(search_params)

    assert_equal "Robertos", results.first.name
    assert_equal 1, results.length
  end


end
