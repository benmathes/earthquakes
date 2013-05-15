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
    # Src,Eqid,Version,Datetime,Lat,Lon,Magnitude,Depth,NST,Region
    @earthquakes = Earthquake.scoped

    # If on and since are both present, return results since the timestamp until the end of that day.
    if params[:on] && params[:since]

    else
      @earthquakes = @earthquakes.on(params[:on])       if params[:on]
      @earthquakes = @earthquakes.since(params[:since]) if params[:since]
    end

    @earthquakes = @earthquakes.over(params[:over])   if params[:over]
    @earthquakes = @earthquakes.near(
      params[:near].split(',').first,
      params[:near].split(',').last,
      params[:radius])                                if params[:near]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @earthquakes }
    end
  end

  # GET /earthquakes/1
  # GET /earthquakes/1.json
  def show
    @earthquake = Earthquake.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @earthquake }
    end
  end

  # GET /earthquakes/new
  # GET /earthquakes/new.json
  def new
    @earthquake = Earthquake.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @earthquake }
    end
  end

  # GET /earthquakes/1/edit
  def edit
    @earthquake = Earthquake.find(params[:id])
  end

  # POST /earthquakes
  # POST /earthquakes.json
  def create
    @earthquake = Earthquake.new(params[:earthquake])

    respond_to do |format|
      if @earthquake.save
        format.html { redirect_to @earthquake, notice: 'Earthquake was successfully created.' }
        format.json { render json: @earthquake, status: :created, location: @earthquake }
      else
        format.html { render action: "new" }
        format.json { render json: @earthquake.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /earthquakes/1
  # PUT /earthquakes/1.json
  def update
    @earthquake = Earthquake.find(params[:id])

    respond_to do |format|
      if @earthquake.update_attributes(params[:earthquake])
        format.html { redirect_to @earthquake, notice: 'Earthquake was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @earthquake.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /earthquakes/1
  # DELETE /earthquakes/1.json
  def destroy
    @earthquake = Earthquake.find(params[:id])
    @earthquake.destroy

    respond_to do |format|
      format.html { redirect_to earthquakes_url }
      format.json { head :no_content }
    end
  end
end
