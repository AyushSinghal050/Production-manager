class AddMaxProductionToItem < ActiveRecord::Migration
  def change
    add_column :items, :MaxProduction, :integer
  end
end
