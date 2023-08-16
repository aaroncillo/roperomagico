class AddReservaDateToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :reserva_date, :date
  end
end
