class AddEstadoToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :estado, :string
  end
end
