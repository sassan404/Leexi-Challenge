require 'json'

class SubscriptionController < Sinatra::Base

  post '/v1/prices' do
    content_type :json
    request_body = request.body.read if request.body
    if request_body.nil? || request_body.empty?
      ($pricing_modules.map do |pricing_module|
        JSON.parse(pricing_module.to_json)
      end).to_json
    else
      begin
        subscription = Subscription.create_from_json(request_body)
        price = subscription.compute_prices.to_json
      rescue Exception => e
        halt 400, { error: "Error with subscription: #{e.message}" }.to_json
      else
        price
      end
    end
  end
end
