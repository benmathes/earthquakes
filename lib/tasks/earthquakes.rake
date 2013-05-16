namespace :earthquakes do

  desc "Idempotently fetch earthquake data"
  task :get => :environment do
    require 'csv'
    earthquakes = eat 'http://earthquake.usgs.gov/earthquakes/catalogs/eqs7day-M1.txt', :timeout => 10

    puts "fetching the list from the USGS"
    earthquakes = CSV.parse(earthquakes, :col_sep => ',')
    earthquakes.delete_at 0 # the descriptor line

    # over time, the number of earthquakes in the DB will vastly outnumber
    # the number of new earthquakes, so we first look for which earthquakes
    # are NOT in the DB already, which will usually be a sparse lookup on the Eqid index.

    # this is a little brittle in that it relies on the proper order of the CSV:
    # Src,Eqid,Version,Datetime,Lat,Lon,Magnitude,Depth,NST,Region

    puts "checking which earthquakes we already know about"
    already_in_our_db = Earthquake.where ['eqid in (?)', earthquakes.map {|e| e[1] } ]
    # make a hash lookup for faster checking
    is_earthquake_in_our_db = {}
    already_in_our_db.each { |earthquake| is_earthquake_in_our_db[earthquake.eqid] = true }

    puts "inserting the new earthquakes..."
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
    puts "#{num_new} new earthquakes"
  end
end