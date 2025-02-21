require_relative 'prices'

class Subscription

  def initialize(plan, number_of_licenses, period)
    ensure_valid_arguments(plan, number_of_licenses, period)
    @plan = plan
    @number_of_licenses = number_of_licenses
    @period = period
  end

  def ensure_valid_arguments(plan, number_of_licenses, period)
    ensure_valid_plan_name(plan)
    ensure_valid_number_of_licenses(number_of_licenses)
    ensure_valid_period(period)
  end

  def ensure_valid_plan_name(plan)
    unless $pricing_plans.include?(plan)
      raise ArgumentError, "Invalid plan name: #{plan}"
    end
  end

  def ensure_valid_period(period)
    unless $pricing_periods.include?(period)
      raise ArgumentError, "Invalid period: #{period}"
    end
  end

  def ensure_valid_number_of_licenses(number_of_licenses)
    unless number_of_licenses.is_a?(Integer) && number_of_licenses >= 0
      raise ArgumentError, "Invalid number_of_licenses: #{number_of_licenses}"
    end
  end

  def Subscription.create (plan, number_of_licenses, period)
    begin
      price = Subscription.new(plan, number_of_licenses, period)
    rescue Exception => e
      return "Error with subscription: #{e.message}"
    else
      return price
    end
  end

  def Subscription.create_from_json (json)
    begin
      data = JSON.parse(json)
      plan = data["plan"]
      number_of_licenses = data["number_of_licenses"]
      period = data["period"]
      price = Subscription.new(plan, number_of_licenses, period)
    rescue Exception => e
      return "Error with subscription: #{e.message}"
    else
      return price
    end
  end

  def compute_prices
    pricing_module = $pricing_modules.find do |pricing_module|
      pricing_module.plan == @plan &&
        pricing_module.min_number_of_licenses <= @number_of_licenses &&
        pricing_module.max_number_of_licenses >= @number_of_licenses
    end
    if pricing_module.nil?
      return "No pricing module found for plan: #{@plan} and number of licenses: #{@number_of_licenses}"
    end
    price = pricing_module.price_per_license * @number_of_licenses
    Prices.new(price, price * 12 * 0.9)
  end
end
