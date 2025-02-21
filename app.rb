require 'sinatra'
require 'json'

require_relative 'app/controllers/hello_world_controller'
require_relative 'app/controllers/pricing_modules_controller'
require_relative 'app/pricingModule/pricing_modules_builder'
require_relative 'app/subscription'
require_relative 'app/controllers/subscription_controller'

set :port, 8080

use HelloWorldController # Mounting the controller
use PricingModulesController # Mounting the builder
use SubscriptionController # Mounting the controller