class AddTodayProductionToItem < ActiveRecord::Migration
  def change
    add_column :items, :today_production, :integer
  end
end
