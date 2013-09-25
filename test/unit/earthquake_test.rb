require 'test_helper'
require 'rake'

class EarthquakeTest < ActiveSupport::TestCase
  test "no duplicate usgs_id's" do
    attributes = {
      usgs_id: 'aslkdfj1234',
      magnitude: 3,
      coordinates: RGeo::Cartesian.factory(srid: Earthquake::SRID).point(1,2)
    }
    Earthquake.create(attributes)
    duplicate = Earthquake.create(attributes)
    assert_equal(['has already been taken'], duplicate.errors.messages[:usgs_id])
  end

  test "average magnitude calculation" do
    assert_equal([4.75, 4.75, 3.0], Earthquake.region_average_magnitude.map(&:average_magnitude).map(&:to_f))
  end

  test "since_days_ago scope" do
    set_fixtures_to_recent_dates
    assert_equal([earthquakes(:a), earthquakes(:near_a)], Earthquake.since_days_ago(4))
  end

  test "in_usa scope" do
    assert_equal([earthquakes(:a), earthquakes(:near_a)], Earthquake.in_usa)
  end

  test "sort_most_dangerous" do
    assert_equal(
      [4.75, 4.75, 3.0],
      Earthquake.region_average_magnitude.sort_most_dangerous.map(&:average_magnitude).map(&:to_f)
    )
  end

end
