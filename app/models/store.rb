class Store < ActiveRecord::Base
  # Tacos and Sauces: These could easily both be HAMT (has_many :through).
  # The ditinguishing factor here is that, at least for the moment, we are not
  # adding any additional functionalty to the join 'model' and are merely using
  # it to connect the models, making a HABTM perfectly acceptable (and a lot cleaner, imo)
  has_and_belongs_to_many :tacos
  has_and_belongs_to_many :salsas, join_table: :stores_salsas

  belongs_to :city

  def self.search(search_params)
    stores = Store.joins(:tacos, :salsas)
    stores
  end

end
