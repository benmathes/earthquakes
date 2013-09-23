class CreateEarthquakes < ActiveRecord::Migration
  def change

    # need to run this on the database initially
    # GRANT SELECT ON geometry_columns TO earthquakes;
    # GRANT SELECT ON geography_columns TO earthquakes;
    # GRANT SELECT ON spatial_ref_sys TO earthquakes;

    create_table :earthquakes do |t|
                              # examples:
      t.string   :usgs_id     # "ak10808672"
      t.float    :magnitude   # 2.6,
      t.boolean  :in_usa      # true
      t.datetime :time        # 1379552172000,
      t.string   :url         # "http://earthquake.usgs.gov/earthquakes/eventpage/ak10808672",
      t.string   :detail      # "http://earthquake.usgs.gov/earthquakes/feed/v1.0/detail/ak10808672.geojson",
      t.string   :title       # "M 2.6 - 59km W of Anchor Point, Alaska"

      # the workhorse: a geometry column for postGIS
      t.point   :coordinates, geographic: true #, srid: Earthquake::SRID
      t.timestamps
    end

    add_index :earthquakes, :usgs_id, unique: true
    add_index :earthquakes, :time
    add_index :earthquakes, :magnitude
    add_index :earthquakes, :coordinates, spatial: true
    add_index :earthquakes, :in_usa

  end
end
