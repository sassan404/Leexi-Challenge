require 'json'

class PricingModulesController < Sinatra::Base

  get '/v1/prices' do
    content_type :json
    temp = $pricing_modules.map do |pricing_module|
      JSON.parse(pricing_module.to_json)
    end
    temp.to_json
  end
end
