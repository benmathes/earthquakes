require 'test_helper'
require 'rake'

class EarthquakesControllerTest < ActionController::TestCase

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

end
