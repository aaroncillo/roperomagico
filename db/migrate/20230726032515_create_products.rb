class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :disfraz
      t.text :agregado
      t.integer :valor
      t.integer :garantia
      t.date :init_date
      t.date :end_date
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
