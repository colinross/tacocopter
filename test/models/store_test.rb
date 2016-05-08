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

end
