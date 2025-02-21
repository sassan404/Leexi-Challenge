require_relative 'test_helper'

class PricingModuleTest < Minitest::Test

  def assert_exception (message, *args)
    error = assert_raises(ArgumentError) do
      PricingModule.create(*args)
    end
    assert_equal error.message, "Error with pricing module: #{message}"
  end

  def test_fake_plan_name
    assert_exception("Invalid plan name: Pricing Module 1", "Pricing Module 1", 1, 1, 1)
  end

  def test_enterprise_typo
    assert_exception("Invalid plan name: entrprise", "entrprise", 1, 1, 1)
  end

  def test_negative_min_number_of_licenses
    assert_exception("Invalid min_number_of_licenses: -1", "aiMeeting", -1, 1, 1)
  end

  def test_float_min_number_of_licenses
    assert_exception("Invalid min_number_of_licenses: 1.5", "aiMeeting", 1.5, 1, 1)
  end

  def test_invalid_max_number_of_licenses
    assert_exception("Invalid max_number_of_licenses: 1.5", "aiMeeting", 1, 1.5, 1)
  end

  def test_negative_price_per_license
    assert_exception("Invalid price_per_license: -1", "aiMeeting", 1, 1, -1)
  end

  def test_invalid_price_per_license
    assert_exception("Invalid price_per_license: abc", "aiMeeting", 1, 1, "abc")
  end

  def test_min_higher_than_max
    assert_exception("min_number_of_licenses should be less than or equal to max_number_of_licenses", "aiMeeting", 2, 1, 1)
  end

  def test_number_of_arguments
    assert_exception("Invalid number of arguments", "aiMeeting")
    assert_exception("Invalid number of arguments", "aiMeeting", 1)
    assert_exception("Invalid number of arguments", "aiMeeting", 1, 1, 1, 1)
    assert_exception("Invalid number of arguments", "aiMeeting", 1, 1, 1, 1, 1)
  end

  def test_get_prices_api
    get '/v1/prices' # Simulate GET request to `/`
    assert last_response.ok?
    assert_equal "application/json", last_response.content_type
    expected_response = [
      { "plan": "aiMeeting", "min_number_of_licenses": 0, "price_per_license": 29, "max_number_of_licenses": 9 },
      { "plan": "aiMeeting", "min_number_of_licenses": 10, "price_per_license": 25, "max_number_of_licenses": 50 },
      { "plan": "aiMeeting", "min_number_of_licenses": 50, "price_per_license": 15 },
      { "plan": "enterprise", "min_number_of_licenses": 10, "price_per_license": 55, "max_number_of_licenses": 50 },
      { "plan": "enterprise", "min_number_of_licenses": 50, "price_per_license": 40 }
    ]
    assert_equal(expected_response.to_json, last_response.body)
  end

  def test_post_without_load_prices_api
    post '/v1/prices' # Simulate GET request to `/`
    assert last_response.ok?
    assert_equal "application/json", last_response.content_type
    expected_response = [
      { "plan": "aiMeeting", "min_number_of_licenses": 0, "price_per_license": 29, "max_number_of_licenses": 9 },
      { "plan": "aiMeeting", "min_number_of_licenses": 10, "price_per_license": 25, "max_number_of_licenses": 50 },
      { "plan": "aiMeeting", "min_number_of_licenses": 50, "price_per_license": 15 },
      { "plan": "enterprise", "min_number_of_licenses": 10, "price_per_license": 55, "max_number_of_licenses": 50 },
      { "plan": "enterprise", "min_number_of_licenses": 50, "price_per_license": 40 }
    ]
    assert_equal(expected_response.to_json, last_response.body)
  end
end
