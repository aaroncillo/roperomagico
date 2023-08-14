class RutToClients < ActiveRecord::Migration[7.0]
  def change
    add_column :clients, :rut, :string
  end
end
