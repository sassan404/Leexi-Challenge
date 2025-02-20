ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
require_relative '../app' # Load your Sinatra app
require_relative 'custom_reporter' # Load custom reporter

class Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application # Define the Sinatra app for testing
  end
end
