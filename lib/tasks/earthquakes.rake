namespace :earthquakes do

  desc "Idempotently fetch earthquake data"
  task :import => :environment do
    Earthquake.import_from_usgs
  end
end