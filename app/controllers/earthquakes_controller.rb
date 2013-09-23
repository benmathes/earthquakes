class EarthquakesController < ApplicationController

  # GET args:
  # count    -> Integer; Number of quakes to return. Defaults to 10
  # days     -> Integer; Number of days from today to look back. Defaults to 10
  # location -> String; "US" or "All". Defaults to ALL
  # region   -> Boolean; If true, group by region. If false or not present, stick with "places" (i.e. Default to "place")
  # sort     -> Boolean: If true, most dangerous (avg magnitude) of quakes in a region. default true.
  def index
    @earthquakes = Earthquake.scoped

    # defaults
    params.merge({
      count:    10,
      days:     10,
      location: 'ALL',
      region:   'place',
      sort:     true
    })

    @earthquakes.limit(params[:count].to_i)
    @earthquakes.since_days_ago(params[:days].to_i)
    @earthquakes.in_usa if params[:location].to_s === 'US'
    # important to call this last, see method comments.
    # not ideal, but this is a one-off project.
    @earthquakes.sort_most_dangerous if params[:sort]
    @earthquakes.avg_magnitude if params[:region]

    respond_to do |format|
      format.html
      format.json { render :json => @earthquakes }
    end
  end
end
