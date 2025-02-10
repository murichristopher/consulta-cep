class AddLatLongToAddress < ActiveRecord::Migration[8.0]
  def change
    add_column :addresses, :lat, :string
    add_column :addresses, :lng, :string
  end
end
