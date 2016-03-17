# spec/spec_helper.rb

# We need to set the environment to test
ENV['RACK_ENV'] = 'test'

require 'ostruct'
require 'factory_girl'
require 'mongoid_cleaner'
require 'rack/test'

# We need to load our application
require_relative '../application.rb'

# Those two files are created later in the jutsu
# but we can already include them
require_relative './factories.rb'
require_relative './support/helpers.rb'

# Defining the app to test is required for rack-test
OUTER_APP = Rack::Builder.parse_file('config.ru').first

# Base URL constant for our future tests
BASE_URL = 'http://example.org:80/api/v1'

RSpec.configure do |config|
  # Load the helpers file required earlier
  config.include Helpers

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # We put this to use create & build directly
  # without using the prefix FactoryGirl
  config.include FactoryGirl::Syntax::Methods

  # Setup Mongoid Cleaner to clean everything before
  # and between each test
  config.before(:suite) do
    MongoidCleaner.strategy = :drop
  end

  config.around(:each) do |example|
    MongoidCleaner.cleaning do
      example.run
    end
  end
end
