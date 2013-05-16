require 'test_helper'

class EarthquakesControllerTest < ActionController::TestCase
  setup do
    @earthquake = earthquakes(:one)
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

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create earthquake" do
    assert_difference('Earthquake.count') do
      @earthquake.eqid = @earthquake.eqid + 'foo' # unique column, would fail otherwise.
      post :create, earthquake: @earthquake.attributes
    end

    assert_redirected_to earthquake_path(assigns(:earthquake))
  end

  test "should show earthquake" do
    get :show, id: @earthquake
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @earthquake
    assert_response :success
  end

  test "should update earthquake" do
    put :update, id: @earthquake, earthquake: @earthquake.attributes
    assert_redirected_to earthquake_path(assigns(:earthquake))
  end

  test "should destroy earthquake" do
    assert_difference('Earthquake.count', -1) do
      delete :destroy, id: @earthquake
    end

    assert_redirected_to earthquakes_path
  end
end
