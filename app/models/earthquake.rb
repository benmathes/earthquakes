class Earthquake < ActiveRecord::Base

  USGS_URL = 'http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_month.geojson'

  # A Spatial Reference System Identifier (SRID) is a unique value used to unambiguously
  # identify projected, unprojected, and local spatial coordinate system definitions. These
  # coordinate systems form the heart of all GIS applications. SRID 4326 is for lat/lon on a globe.
  # so calculations about nearness/distance are spherical.
  SRID = 4326

  DEFAULT_RADIUS_MILES = 25

  METERS_PER_MILE = 1609

  # does it work on heroku? https://devcenter.heroku.com/articles/postgis

  # I'd like to cluster (i.e. k-means) the earthquakes and define _those_ as regions, and update
  # the region definitions periodically (say, daily). Limited time for the project, though :-)

  FACTORY = RGeo::Cartesian.factory(srid: SRID)

  validates :usgs_id, uniqueness: true, presence: true
  validates :coordinates, presence: true
  validates :magnitude, presence: true

  module Scopes

    def since_days_ago(num_days)
      where(['earthquakes.time >= ?', num_days.days.ago.beginning_of_day])
    end

    def in_usa
      where(in_usa: true)
    end

    # include all earthquakes within a region (<= 25 miles from this earthquake).
    # GOTCHA: to scope the regions as well, need to call this last, see "scoping_for_surrounding_quakes"
    # e.g. Earthquake.since_days_ago(3).region_within(10)
    def avg_magnitude(radius_miles = DEFAULT_RADIUS_MILES)
      relation = self.select(['earthquakes.*', 'avg(surrounding_earthquakes.magnitude) as average_magnitude'])
        .group('earthquakes.id')
        .joins(sanitize_sql([
          "left join earthquakes as surrounding_earthquakes
          on ST_DWithin(earthquakes.coordinates, surrounding_earthquakes.coordinates, %d)",
          METERS_PER_MILE * radius_miles # ~1609 meters per mile
        ]))

      # when including other earthquakes within a region,
      # they need to be scoped (e.g. within x days) just
      # like the base earthquakes table. Hackish approach:
      # pull the where clauses from the base ActiveRecord::Relation
      # and apply it to the surrounding_earthquakes
      scoping_for_surrounding_quakes = relation.where_values.map do |clause|
        where_clause_sql = clause.kind_of?(String) ? clause : clause.to_sql
        where_clause_sql.sub('earthquakes', 'surrounding_earthquakes')
      end
      if scoping_for_surrounding_quakes.count > 0
        relation.where('(' + scoping_for_surrounding_quakes.join(' and ') + ')')
      end
      relation
    end


    def sort_most_dangerous
      self.order('average_magnitude desc')
    end
  end
  extend Scopes

  def average_magnitude
    read_attribute(:average_magnitude) || nil
  end

end
