namespace :earthquakes do
  desc "Idempotently fetch earthquake data"
  task :import => :environment do
    raw_json = JSON.parse(eat(Earthquake::USGS_URL, timeout: 10))
    new_earthquakes = raw_json['features']

    # over time, the number of earthquakes in the DB will vastly outnumber
    # the number of new earthquakes, so we first look for which earthquakes
    # are NOT in the DB already, which will usually be a sparse lookup on the Eqid index.
    already_in_our_db = Earthquake.where([
      'usgs_id in (?)',
      new_earthquakes.map{ |earthquake| earthquake['id'] }.reject(&:nil?)
    ])

    # make a hash lookup for faster checking
    is_earthquake_in_our_db = {}
    already_in_our_db.each { |earthquake| is_earthquake_in_our_db[earthquake.usgs_id] = true }
    new_earthquakes.reject!{ |earthquake| is_earthquake_in_our_db[earthquake['id']] }

    new_earthquakes = new_earthquakes.map do |earthquake|
      # for this toy project, discard data that we won't use.
      # For a long-term project, we'd probably keep a lot of
      # the extra metadata around for future use.
      {
        usgs_id:     earthquake['id'],
        magnitude:   earthquake['properties']['mag'],
        place:       earthquake['properties']['place'],
        time:        Time.at(earthquake['properties']['time']/1000.0).to_datetime,
        url:         earthquake['properties']['url'],
        detail:      earthquake['properties']['detail'],
        title:       earthquake['properties']['title'],
        coordinates: RGeo::Cartesian.factory(srid: Earthquake::SRID).point(
          earthquake['geometry']['coordinates'][0],
          earthquake['geometry']['coordinates'][1]
        ),
      }
    end

    puts "  Creating #{new_earthquakes.count} new earthquakes..."
    Earthquake.create!(new_earthquakes)
    puts "  ...done"
  end
end
