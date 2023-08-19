class CreatePagos < ActiveRecord::Migration[7.0]
  def change
    create_table :pagos do |t|
      t.string :name_gasto
      t.text :description_gasto
      t.integer :precio_gasto
      t.date :fecha_gasto
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
