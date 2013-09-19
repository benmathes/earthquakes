class AddSearchIndexesToEarthquakes < ActiveRecord::Migration
  def change
    add_index :earthquakes, :id, :unique => true
    add_index :earthquakes, :time
    add_index :earthquakes, :magnitude
    add_index :earthquakes, :latitude
    add_index :earthquakes, :longitude
  end
end
