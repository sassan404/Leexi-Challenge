require 'sinatra'
require 'json'

require_relative 'app/controllers/hello_world_controller'
require_relative 'app/pricingModule/pricing_modules_builder'

set :port, 8080

use HelloWorldController # Mounting the controller