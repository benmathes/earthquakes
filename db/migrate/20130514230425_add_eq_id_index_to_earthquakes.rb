class AddEqIdIndexToEarthquakes < ActiveRecord::Migration
  def change
    add_index :earthquakes, :eqid, :unique => true
  end
end
