class Earthquake < ActiveRecord::Base

  USGS_URL = 'http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_month.geojson'

  SRID = 4326

  FACTORY = RGeo::Cartesian.factory(srid: SRID)

  validates :usgs_id, uniqueness: true, presence: true
  validates :coordinates, presence: true
  validates :magnitude, presence: true

  module Scopes
    def in_box(sw_lon, sw_lat, ne_lon, ne_lat)
      sw = FACTORY.point(sw_lon, sw_lat)
      nw = FACTORY.point(sw_lon, ne_lat)
      ne = FACTORY.point(ne_lon, ne_lat)
      se = FACTORY.point(ne_lon, sw_lat)
      bounding_box = FACTORY.polygon(FACTORY.linear_ring([sw, nw, ne, se]))
      self.where([' ST_Intersects(coordinates, :bounding_box) ', { bounding_box: bounding_box }])
    end
  end
  extend Scopes

  # does it work on heroku? https://devcenter.heroku.com/articles/postgis

  # region as defined by A GIS group_by?, e.g. http://gis.stackexchange.com/questions/11567/spatial-clustering-with-postgis

end
