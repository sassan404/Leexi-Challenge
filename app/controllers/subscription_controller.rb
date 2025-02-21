require 'json'

class SubscriptionController < Sinatra::Base

  post '/v1/prices' do
    content_type :json
    request_body = request.body.read
    subscription = Subscription.create_from_json(request_body)
    subscription.compute_prices.to_json
  end
end
