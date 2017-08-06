class CreateRawMaterials < ActiveRecord::Migration
  def change
    create_table :raw_materials do |t|
      t.string :name
      t.integer :quantity
      t.string :weightin

      t.timestamps null: false
    end
  end
end
