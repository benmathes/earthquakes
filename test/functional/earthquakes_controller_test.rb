require 'test_helper'

class EarthquakesControllerTest < ActionController::TestCase

  test "should get index" do
    set_fixtures_to_recent_dates
    get :index
    assert_response :success
    assert_not_nil assigns(:earthquakes)
  end

  test "should get earthquakes within x days" do
    set_fixtures_to_recent_dates
    get :index, days: Date.today - earthquakes(:a).time.to_date
    assert_response :success
    assert_not_nil assigns(:earthquakes)
    assert_includes(assigns(:earthquakes), earthquakes(:a))
  end

  test "should limit number of earthquakes returned" do
    set_fixtures_to_recent_dates
    get :index, count: 1
    assert_response :success
    assert_not_nil assigns(:earthquakes)
    assert_equal(assigns(:earthquakes).count, 1)
  end

  test "should limit to US" do
    set_fixtures_to_recent_dates
    get :index, location: "US"
    assert_response :success
    assert_not_nil assigns(:earthquakes)
    assert_equal(assigns(:earthquakes).map(&:in_usa), [true, true])
  end

  test "should not limit via 'ALL'" do
    set_fixtures_to_recent_dates
    get :index, location: "ALL"
    assert_response :success
    assert_not_nil assigns(:earthquakes)
    assert_equal(assigns(:earthquakes).map(&:in_usa), [true, true, false])
  end

  test "don't group by region" do
    set_fixtures_to_recent_dates
    get :index, region: false
    assert_response :success
    assert_not_nil assigns(:earthquakes)
    assert_equal(assigns(:earthquakes).map{|e| e.average_magnitude }, [nil, nil, nil])
  end

end
