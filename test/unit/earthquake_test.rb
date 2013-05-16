require 'test_helper'

class EarthquakeTest < ActiveSupport::TestCase
  test "no duplicate eqid's" do
    Earthquake.create :eqid => 1234
    duplicate = Earthquake.create :eqid => 1234
    assert_equal(['has already been taken'], duplicate.errors.messages[:eqid], 'a duplicate eqid should not be allowed')
  end


  # no testing of the scopes, because they're so simple
  # I would just be flat out duplicating the same simple logic (e.g.
  # greater_than comparison of magnitudes). And if you're duplicating
  # logic you're not really testing anything.

end
