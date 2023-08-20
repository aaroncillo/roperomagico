class DropTableName < ActiveRecord::Migration[7.0]
  def change
    drop_table :gastos
  end
end
