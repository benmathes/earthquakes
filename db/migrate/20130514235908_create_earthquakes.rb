class CreateEarthquakes < ActiveRecord::Migration
  def change
    create_table :earthquakes, primary_key: :local_id do |t|
                              # examples:
      t.string   :id          # "ak10808672"
      t.float    :magnitude   # 2.6,
      t.string   :place       # "US" or "ALL" 59km W of Anchor Point, Alaska",
      t.datetime :time        # 1379552172000,
      t.string   :url         # "http://earthquake.usgs.gov/earthquakes/eventpage/ak10808672",
      t.string   :detail      # "http://earthquake.usgs.gov/earthquakes/feed/v1.0/detail/ak10808672.geojson",
      t.string   :title       # "M 2.6 - 59km W of Anchor Point, Alaska"
      t.float    :latitude    # 23.34
      t.float    :longitude   # 432.2
      t.float    :depth       # 5
      t.timestamps
    end
  end
end
