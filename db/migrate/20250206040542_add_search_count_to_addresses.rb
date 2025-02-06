class AddSearchCountToAddresses < ActiveRecord::Migration[8.0]
  def change
    add_column :addresses, :search_count, :integer
  end
end
