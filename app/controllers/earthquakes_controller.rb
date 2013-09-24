class EarthquakesController < ApplicationController

  # GET args:
  # count    -> Integer; Number of quakes to return. Defaults to 10
  # days     -> Integer; Number of days from today to look back. Defaults to 10
  # location -> String; "US" or "All". Defaults to ALL
  # region   -> Boolean; If true, group by region. If false or not present, stick with "places" (i.e. Default to "place")
  # sort     -> Boolean: If true, most dangerous (avg magnitude) of quakes in a region. default true.
  def index
    @earthquakes = Earthquake.scoped

    params_with_defaults = HashWithIndifferentAccess.new({
      count:    10,
      days:     10,
      location: 'ALL',
      region:   'place',
      sort:     true,
      radius:   Earthquake::DEFAULT_RADIUS_MILES
    }).merge(params)

    @earthquakes = @earthquakes.limit(params_with_defaults[:count].to_i)
    @earthquakes = @earthquakes.since_days_ago(params_with_defaults[:days].to_i)
    @earthquakes = @earthquakes.in_usa if params_with_defaults[:location].to_s === 'US'
    @earthquakes = @earthquakes.sort_most_dangerous if params_with_defaults[:sort] && params_with_defaults[:region] == 'place'

    # important to call avg_magnitude last, see method comments.
    # not ideal, but this is a one-off project.
    @earthquakes = @earthquakes.avg_magnitude(params_with_defaults[:radius].to_i) if params_with_defaults[:region] == 'place'

    # force the query to run explicitly, since functions like
    # .count on the Arel will fail since we've done some custom
    # additions to the selects and order by's, but rails will squash
    # the additional select clause (the average magnitude)
    @earthquakes = @earthquakes.all

    respond_to do |format|
      format.html
      format.json { render :json => @earthquakes }
    end
  end
end
