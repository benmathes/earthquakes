class EarthquakesController < ApplicationController

  # GET args:
  # count     -> Integer; Number of quakes to return. Defaults to 10
  # days      -> Integer; Number of days from today to look back. Defaults to 10
  # location  -> String; "US" or "All". Defaults to ALL
  # region    -> Boolean; If true, group by region. If false or not present, stick with "places" (i.e. Default to "place")
  def index
    @earthquakes = Earthquake.scoped

    respond_to do |format|
      format.html
      format.json { render :json => @earthquakes }
    end
  end
end
