require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

# SimpleCov.start must be issued before any application code is required
require 'simplecov'
SimpleCov.start

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  include Devise::TestHelpers
  include FactoryGirl::Syntax::Methods
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include Devise::TestHelpers

  # Add more helper methods to be used by all tests here...
end
