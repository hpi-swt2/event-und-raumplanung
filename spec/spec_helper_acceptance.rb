require 'simplecov'
SimpleCov.start 'rails'

require 'rails_helper'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/webkit/matchers' # for JS support
require 'helpers/user_helper_spec'
require 'factory_girl_rails'

require "rack_session_access/capybara"

require 'database_cleaner'

include Warden::Test::Helpers
Warden.test_mode!

RSpec.configure do |config|

  # If you want to explude tests e.g. acceptance test just flag them with "exclude: true"
  config.filter_run_excluding :exclude => true

  # The name of this setting is a bit misleading. What it really means in Rails
  # is "run every test method within a transaction." In the context of rspec-rails,
  # it means "run every example within a transaction."
  #
  # The idea is to start each example with a clean database, create whatever data
  # is necessary for that example, and then remove that data by simply rolling back
  # the transaction at the end of the example.
  config.use_transactional_fixtures = false
  
  config.include Devise::TestHelpers, type: :controller
  config.include UserHelper
  config.include Capybara::DSL
  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|

    expectations.include_chain_clauses_in_custom_matcher_descriptions = true

    config.before(:all) do
      DatabaseCleaner.strategy = :truncation
      # DatabaseCleaner.clean

      DatabaseCleaner.clean_with(:truncation)
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  Capybara.javascript_driver = :webkit
end
