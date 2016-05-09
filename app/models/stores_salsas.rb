class StoresSalsas < ActiveRecord::Base
  belongs_to :store
  belongs_to :salsa

  scope :store_ids_with_all_salsa_types, ->(ids) do
    where(salsa_id: ids).\
    group(:store_id).\
    having("count(store_id) = ?", ids.size).\
    pluck(:store_id).uniq
  end

end
