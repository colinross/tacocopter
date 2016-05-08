class StoresController < ApplicationController
  # While traditionally you would implement this a protected method like 'search_params',
  # that makes it really hard to test in isolation since you have to then deal with
  # stubbing and/or mocking out the call to 'params' in your tests.
  class SearchParams
    def self.build params
      filtered_params = params.require(:search).permit(:taco_ids => [], :salsa_ids => [])
    end
  end

  # GET stores/search
  def search_form; end

  # POST stores/search
  def search
    @stores = Store.search(SearchParams.build(params))
  end

end
