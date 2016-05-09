class Store < ActiveRecord::Base
  has_and_belongs_to_many :tacos
  has_and_belongs_to_many :salsas, join_table: :stores_salsas
  belongs_to :city  #city_id -> name

  # The 'with_all_*_types' scopes use a single query to detirmine the stores that
  # serve each food type by count. For instance, we know how many taco types we are
  # asking for (type_ids.length), and therefore, any stores with less than that
  # many matches is not valid and should be excluded.
  # There are alternatives to this method (such as doing an inner join for each
  # type you are looking for
  scope :with_all_taco_types, ->(type_ids) do
    where(id: StoresTacos.store_ids_with_all_taco_types(type_ids))
  end
  scope :with_all_salsa_types, ->(type_ids) do
    where(id: StoresSalsas.store_ids_with_all_salsa_types(type_ids))
  end

  def self.search(search_params)
    applicable_scopes = %w{taco salsa}.collect do |type|
      values = search_params.fetch(type.foreign_key.pluralize)
      next unless values.present?
      cond = send("with_all_#{type}_types", values)
    end.compact #collect returns a nils, not nothing when you call next
    relation = applicable_scopes.inject(includes(:city),:&)

  end

end
