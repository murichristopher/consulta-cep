class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :cep, null: false, unique: true
      t.string :street
      t.string :district
      t.string :city
      t.string :state
      t.string :ddd

      t.timestamps
    end
    add_index :addresses, :cep, unique: true
  end
end
