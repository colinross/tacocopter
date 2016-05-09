class StoresTacos < ActiveRecord::Base
  belongs_to :store
  belongs_to :taco

  scope :store_ids_with_all_taco_types, ->(ids) do
    where(taco_id: ids).\
    group(:store_id).\
    having("count(store_id) = ?", ids.size).\
    pluck(:store_id).uniq
  end

end
