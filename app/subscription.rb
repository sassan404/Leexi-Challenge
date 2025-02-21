require_relative 'prices'

class Subscription

  def initialize(plan, number_of_licenses, period)
    ensure_valid_arguments(plan, number_of_licenses, period)
    @plan = plan
    @number_of_licenses = number_of_licenses
    @period = period
    @pricing_module = get_pricing_module
  end

  def get_pricing_module
    pricing_module = $pricing_modules.find do |pricing_module|
      pricing_module.plan == @plan &&
        pricing_module.min_number_of_licenses <= @number_of_licenses &&
        pricing_module.max_number_of_licenses >= @number_of_licenses
    end
    if pricing_module.nil?
      raise NoMatchingPatternError, "No pricing module found for plan: #{@plan} and number of licenses: #{@number_of_licenses}"
    end
    pricing_module
  end

  def ensure_valid_arguments(plan, number_of_licenses, period)
    ensure_valid_plan_name(plan)
    ensure_valid_number_of_licenses(number_of_licenses)
    ensure_valid_period(period)
  end

  def ensure_valid_plan_name(plan)
    unless $pricing_plans.include?(plan)
      Subscription.raise_argument_error("Invalid plan name: #{plan}")
    end
  end

  def ensure_valid_period(period)
    unless $pricing_periods.include?(period)
      Subscription.raise_argument_error("Invalid period: #{period}")
    end
  end

  def ensure_valid_number_of_licenses(number_of_licenses)
    unless number_of_licenses.is_a?(Integer) && number_of_licenses >= 0
      Subscription.raise_argument_error("Invalid number_of_licenses: #{number_of_licenses}")
    end
  end

  def Subscription.create (plan, number_of_licenses, period)
    price = Subscription.new(plan, number_of_licenses, period)
    return price
  end

  def Subscription.create_from_json (json)
    data = JSON.parse(json)
    plan = data["plan"]
    number_of_licenses = data["numberOfLicenses"]
    period = data["period"]
    Subscription.new(plan, number_of_licenses, period)
  end

  def compute_prices
    price = @pricing_module.price_per_license * @number_of_licenses
    Prices.new(price, price * 12 * 0.9)
  end

  def Subscription.raise_argument_error(message)
    raise ArgumentError, "Error with subscription: #{message}"
  end

end
