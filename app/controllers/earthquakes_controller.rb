class EarthquakesController < ApplicationController
  # GET /earthquakes
  # GET /earthquakes.json
  #
  # GET /earthquakes.<format>?on=1364582194
  # # Returns earthquakes on the same day (UTC) as the unix timestamp 1364582194
  #
  # GET /earthquakes.<format>?since=1364582194
  #   # Returns earthquakes since the unix timestamp 1364582194
  #
  # GET /earthquakes.<format>?over=3.2
  # # Returns earthquakes > 3.2 magnitude
  #
  # GET /earthquakes.<format>?near=36.6702,-114.8870&radius=10
  #   # Returns all earthquakes within 5 miles of lat: 36.6702, lng: -114.8870
  #
  def index
    @earthquakes = Earthquake.scoped

    # If on and since are both present, return results since the timestamp until the end of that day.
    if params[:on] && params[:since]
      @earthquakes = @earthquakes.until_end_of_day params[:since]
    else
      @earthquakes = @earthquakes.on params[:on] if params[:on]
      @earthquakes = @earthquakes.since params[:since] if params[:since]
    end

    @earthquakes = @earthquakes.over params[:over] if params[:over]

    # format is $url?near=lat,lon
    if params[:near]
      @earthquakes = @earthquakes.near(
        params[:near].split(',').first,
        params[:near].split(',').last,
        params[:radius]
      )
    end

    respond_to do |format|
      format.html
      format.json { render :json => @earthquakes }
    end
  end
end
