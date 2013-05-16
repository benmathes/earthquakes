require 'test_helper'

class EarthquakeTest < ActiveSupport::TestCase
  test "no duplicate eqid's" do
    Earthquake.create :eqid => 1234
    duplicate = Earthquake.create :eqid => 1234
    assert_equal(['has already been taken'], duplicate.errors.messages[:eqid], 'a duplicate eqid should not be allowed')
  end

  test "idempotency of import" do
    # fetch the list once and try and insert it twice.
    # we manually fetch it and re-use it in case the USGS
    # adds a new earthquake between the two import calls (a race condition)
    import_list = Earthquake.usgs_list
    before = Earthquake.count
    Earthquake.import_from_usgs import_list
    after = Earthquake.count
    assert_operator(before, :<, after, 'first insert should add rows')

    before = Earthquake.count
    Earthquake.import_from_usgs import_list
    after = Earthquake.count
    assert_equal(before, Earthquake.count, 'first insert should add rows')
  end

  # no testing of the scopes, because they're so simple
  # I would just be flat out duplicating the same simple logic (e.g.
  # greater_than comparison of magnitudes). And if you're duplicating
  # logic you're not really testing anything.

end
