class AddSearchIndexesToEarthquakes < ActiveRecord::Migration
  def change
    add_index :earthquakes, :datetime
    add_index :earthquakes, :magnitude
    add_index :earthquakes, :lat
    add_index :earthquakes, :lon
  end
end