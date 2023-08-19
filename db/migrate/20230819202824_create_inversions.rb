class CreateInversions < ActiveRecord::Migration[7.0]
  def change
    create_table :inversions do |t|
      t.string :name_inversion
      t.text :description_inversion
      t.integer :precio_inversion
      t.date :fecha_inversion
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
