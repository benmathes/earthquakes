class Earthquake < ActiveRecord::Base
  USGS_URL = 'http://earthquake.usgs.gov/earthquakes/catalogs/eqs7day-M1.txt'

  validates :eqid, :uniqueness => true

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
          cos( radians(?) ) *
          cos( radians( lat ) ) *
          cos( radians( lon ) - radians(?) ) +
          sin( radians(?) ) *
          sin( radians( lat ) )
        )) < ?',
        latitude, longitude, latitude, radius_miles
      )
    end

    def until_end_of_day(unix_timestamp)
      where('datetime between ? and ?', Time.at(unix_timestamp.to_i), Time.at(unix_timestamp.to_i).end_of_day.to_datetime)
    end

  end
  extend Scopes


  def self.usgs_list
    eat USGS_URL, :timeout => 10
  end

  def self.import_from_usgs(csv_text = '')
    require 'csv' #hacky.

    earthquakes = CSV.parse csv_text.present? ? csv_text : usgs_list, :col_sep => ','
    earthquakes.delete_at 0 # the descriptor line
    earthquakes.delete_at 0 # the "this will be deprecated soon" line

    # over time, the number of earthquakes in the DB will vastly outnumber
    # the number of new earthquakes, so we first look for which earthquakes
    # are NOT in the DB already, which will usually be a sparse lookup on the Eqid index.

    # this is a little brittle in that it relies on the proper order of the CSV:
    # Src,Eqid,Version,Datetime,Lat,Lon,Magnitude,Depth,NST,Region
    already_in_our_db = Earthquake.where ['eqid in (?)', earthquakes.map {|e| e[1] } ]

    # make a hash lookup for faster checking
    is_earthquake_in_our_db = {}
    already_in_our_db.each { |earthquake| is_earthquake_in_our_db[earthquake.eqid] = true }

    num_new = 0
    earthquakes.each do |earthquake|
      unless is_earthquake_in_our_db[earthquake[1]]
        num_new = num_new.succ
        Earthquake.create(
          :src => earthquake[0],
          :eqid => earthquake[1],
          :version => earthquake[2],
          :datetime => earthquake[3],
          :lat => earthquake[4],
          :lon => earthquake[5],
          :magnitude => earthquake[6],
          :depth => earthquake[7],
          :nst => earthquake[8],
          :region => earthquake[9]
        )
      end
    end
  end

end
