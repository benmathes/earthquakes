class Earthquake < ActiveRecord::Base
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

    def near(latitude, longitude, radius_miles=5)
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

  validates :eqid, :uniqueness => true
end
