require_relative 'test_helper'

class SubscriptionTest < Minitest::Test

  def assert_exception (message, *args)
    error = assert_raises(ArgumentError) do
      Subscription.create(*args)
    end
    assert_equal error.message, "Error with subscription: #{message}"
  end

  def test_fake_plan_name
    assert_exception("Invalid plan name: Pricing Module 1", "Pricing Module 1", 1, 1)
  end

  def test_negative_number_of_licenses
    assert_exception("Invalid number_of_licenses: -1", "aiMeeting", -1, "monthly")
  end

  def test_decimal_number_of_licenses
    assert_exception("Invalid number_of_licenses: 1.5", "aiMeeting", 1.5, "monthly")
  end

  def test_invalid_period
    assert_exception("Invalid period: abc", "aiMeeting", 1, "abc")
  end

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

  def test_enterprise_with_little_licenses
    body_in_json = { plan: "enterprise", number_of_licenses: 5, period: "monthly" }.to_json
    post '/v1/prices', body_in_json, { "CONTENT_TYPE" => "application/json" }
    assert !last_response.ok?
    assert last_response.status == 400
    assert_equal "application/json", last_response.content_type
    expected_response = { error: "Error with subscription: No pricing module found for plan: enterprise and number of licenses: 5" }
    assert_equal(expected_response.to_json, last_response.body)
  end

  def test_price_calculation_ai_meeting_10
    model = Subscription.create("aiMeeting", 5, "monthly")
    prices = model.compute_prices
    assert_equal 5 * 29, prices.monthly
    assert_equal 5 * 29 * 12 * 0.9, prices.annually
  end

  def test_price_calculation_ai_meeting_10_50
    model = Subscription.create("aiMeeting", 20, "monthly")
    prices = model.compute_prices
    assert_equal 20 * 25, prices.monthly
    assert_equal 20 * 25 * 12 * 0.9, prices.annually
  end

  def test_price_calculation_ai_meeting_50
    model = Subscription.create("aiMeeting", 60, "monthly")
    prices = model.compute_prices
    assert_equal 60 * 15, prices.monthly
    assert_equal 60 * 15 * 12 * 0.9, prices.annually
  end

  def test_price_calculation_enterprise_10
    error = assert_raises(NoMatchingPatternError) do
      Subscription.create("enterprise", 5, "monthly")
    end
    assert_equal "No pricing module found for plan: enterprise and number of licenses: 5", error.message
  end

  def test_price_calculation_enterprise_10_50
    model = Subscription.create("enterprise", 20, "monthly")
    prices = model.compute_prices
    assert_equal 20 * 55, prices.monthly
    assert_equal 20 * 55 * 12 * 0.9, prices.annually
  end

  def test_price_calculation_enterprise_50
    model = Subscription.create("enterprise", 60, "monthly")
    prices = model.compute_prices
    assert_equal 60 * 40, prices.monthly
    assert_equal 60 * 40 * 12 * 0.9, prices.annually
  end
end
