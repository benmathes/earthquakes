class Earthquake < ActiveRecord::Base

  USGS_URL = 'http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_month.geojson'

  validates :id, :uniqueness => true

  module Scopes
    def on(unix_timestamp)
      where(:datetime => Time.at(unix_timestamp.to_i).to_datetime)
    end

    def since(unix_timestamp)
      where('datetime > ?', Time.at(unix_timestamp.to_i).to_datetime)
    end

    def over(magnitude)
      where('magnitude > ?', magnitude)
    end

    def near(latitude, longitude, radius_miles = 5)
      where(
        '( 3959 * acos(
          cos( radians( :latitude ) ) *
          cos( radians( latitude  ) ) *
          cos( radians( longitude ) - radians(:longitude) ) +
          sin( radians( :latitude ) ) *
          sin( radians( latitude ) )
        )) < :radius_miles',
        {
          latitude: latitude,
          longitude: longitude,
          radius_miles: radius_miles
        }
      )
    end

    def until_end_of_day(unix_timestamp)
      where('datetime between ? and ?', Time.at(unix_timestamp.to_i), Time.at(unix_timestamp.to_i).end_of_day.to_datetime)
    end
  end
  extend Scopes


  # postgres GIS? http://postgis.net/install
  # does it work on heroku? https://devcenter.heroku.com/articles/postgis

  # region as defined by the ascii files?
  # region as defined by A GIS group_by?, e.g. http://gis.stackexchange.com/questions/11567/spatial-clustering-with-postgis

end
