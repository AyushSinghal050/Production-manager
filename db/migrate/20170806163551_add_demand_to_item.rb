class AddDemandToItem < ActiveRecord::Migration
  def change
    add_column :items, :Demand, :integer
  end
end
