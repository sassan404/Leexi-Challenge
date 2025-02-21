require_relative 'test_helper'

class SubscriptionTest < Minitest::Test

  def test_subscription_creation
    model = Subscription.create("aiMeeting", 1, "monthly")
    assert_instance_of Subscription, model
  end

  def test_subscription_creation_from_json
    model = Subscription.create_from_json('{ "plan": "aiMeeting", "number_of_licenses": 1, "period": "monthly" }')
    assert_instance_of Subscription, model
  end

  def test_subscription_api
    body_in_json = { plan: "aiMeeting", number_of_licenses: 20, period: "monthly" }.to_json
    post '/v1/prices', body_in_json, { "CONTENT_TYPE" => "application/json" }
    assert last_response.ok?
    assert_equal "application/json", last_response.content_type
    expected_response = { "prices": { "monthly": 500, "annually": 5400.0 } }
    assert_equal(expected_response.to_json, last_response.body)
  end
end
