class Store < ActiveRecord::Base
  has_and_belongs_to_many :tacos
  has_and_belongs_to_many :salsas, join_table: :stores_salsas
  belongs_to :city  #city_id -> name

  scope :with_all_taco_types, ->(type_ids) do
    where(id: StoresTacos.store_ids_with_all_taco_types(type_ids))
  end
  scope :with_all_salsa_types, ->(type_ids) do
    where(id: StoresSalsas.store_ids_with_all_salsa_types(type_ids))
  end

  # Store.search
  # search_params: hash of arguments in the form {search_attribute: => [array_of_type_ids], ...}
  # Returns: a built up ActiveRecord Relation containing the matching stores,
  # or an empty 'none' scope if no results
  def self.search(search_params)
    search_params = search_params.with_indifferent_access
    chain = [].tap do |relation|
      relation << with_all_taco_types(search_params[:taco_ids]) if search_params[:taco_ids].present?
      relation << with_all_salsa_types(search_params[:salsa_ids]) if search_params[:salsa_ids].present?
    end
    if chain.present? # if at least one of the scopes was acted on
      chain.reduce(includes(:city), :merge) # Merge all the scopes.
    else
      Store.none
    end
  end

end
