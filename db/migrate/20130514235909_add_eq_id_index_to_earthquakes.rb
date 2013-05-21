class AddEqIdIndexToEarthquakes < ActiveRecord::Migration
  def up
    add_index :earthquakes, :eqid, :unique => true
  end
  def down
    remove_index :earthquakes, :eqid
  end
end
