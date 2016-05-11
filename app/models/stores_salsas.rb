class StoresSalsas < ActiveRecord::Base
  belongs_to :store
  belongs_to :salsa

  # The 'with_all_*_types' scopes use a single query to detirmine the stores that
  # serve each food type by count. For instance, we know how many taco types we are
  # asking for (type_ids.length), and therefore, any stores with less than that
  # many matches is not valid and should be excluded.
  # There are alternatives to this method (such as doing an inner join for each
  # type you are looking for
  scope :store_ids_with_all_salsa_types, ->(ids) do
    where(salsa_id: ids).\
    group(:store_id).\
    having("count(store_id) = ?", ids.size).\
    pluck(:store_id).uniq
  end

end
