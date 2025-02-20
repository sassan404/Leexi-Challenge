require 'sinatra'
require 'json'

require_relative 'app/controllers/hello_world_controller'

set :port, 8080

use HelloWorldController # Mounting the controller