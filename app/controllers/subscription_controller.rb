require 'json'

class SubscriptionController < Sinatra::Base

  post '/v1/prices' do
    content_type :json
    request_body = request.body.read
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
