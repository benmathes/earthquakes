require 'test_helper'

class EarthquakeTest < ActiveSupport::TestCase
  test "no duplicate eqid's" do
    first = Earthquake.create :eqid => earthquakes(:one).eqid
    second = Earthquake.create :eqid => earthquakes(:one).eqid
    assert_equal('has already been taken', second.errors.messages[:eqid], 'a duplicate eqid should not be allowed')
  end
end
