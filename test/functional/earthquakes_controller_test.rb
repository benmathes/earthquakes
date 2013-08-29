require 'test_helper'

class EarthquakesControllerTest < ActionController::TestCase
  setup do
    Earthquake.import_from_usgs
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:earthquakes)
  end

  test "should get earthquakes on set time" do
    get :index, :on => '1337038407'
    assert_response :success
    assert_not_nil assigns(:earthquakes)
    assert_equal("1234", assigns(:earthquakes).first.eqid, "should return the earthquake on that timestamp with eqid 1234")
  end

  test "should get earthquakes on set time, and be strictly greater" do
    get :index, :since => '1337038407'
    assert_response :success
    assert_not_nil assigns(:earthquakes)
    assert_equal( %w[12345 123456], assigns(:earthquakes).map(&:eqid), "should return the earthquakes after given timestamp")
  end


  test "should get earthquakes strictly greater than set magnitude" do
    get :index, :over => 2.1
    assert_response :success
    assert_not_nil assigns(:earthquakes)
    assert_equal( %w[12345 123456], assigns(:earthquakes).map(&:eqid), "should return the earthquakes strictly greater than set magnitude")
  end

  test "should get earthquakes within 50 miles of lat/lon" do
    get :index, :near => "63,-140", :radius => 50
    assert_response :success
    assert_not_nil assigns(:earthquakes)
    assert_equal( %w[1234 12345], assigns(:earthquakes).map(&:eqid), "should return the earthquakes within 50 miles of lat/lon")
  end

  test "should get earthquakes until the end of the day (on & since)" do
    get :index, :since => DateTime.parse('2013-05-14T10:43:27Z').to_time.to_i, :on => "doesnt matter what this is"
    assert_response :success
    assert_not_nil assigns(:earthquakes)
    assert_equal %w[123456], assigns(:earthquakes).map(&:eqid), "should return earthquakes after specified time until EOD"
  end
end
