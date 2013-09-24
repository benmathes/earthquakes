ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # hack: in a fully-fledged project we'd use something like
  # FactoryGirl to do this dynamic fixture creation
  def set_fixtures_to_recent_dates
    earthquakes(:a).update_attribute(:time, Date.today - 3.days)
    earthquakes(:near_a).update_attribute(:time, Date.today - 3.days)
    earthquakes(:not_near_a).update_attribute(:time, Date.today - 5.days)
  end
end
