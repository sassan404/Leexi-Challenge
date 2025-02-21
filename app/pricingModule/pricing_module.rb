require 'json'

class PricingModule

  def initialize(plan, min_number_of_licenses, max_number_of_licenses, price_per_license)
    ensure_valid_arguments(plan, min_number_of_licenses, max_number_of_licenses, price_per_license)
    @plan = plan
    @min_number_of_licenses = min_number_of_licenses
    @max_number_of_licenses = max_number_of_licenses
    @price_per_license = price_per_license
  end

  def ensure_valid_arguments(plan, min_number_of_licenses = 0, max_number_of_licenses = Infinity, price_per_license)
    ensure_valid_plan(plan)
    ensure_valid_min_number_of_licenses(min_number_of_licenses)
    ensure_valid_max_number_of_licenses(max_number_of_licenses)
    ensure_valid_price_per_license(price_per_license)
    ensure_max_is_higher_than_min(min_number_of_licenses, max_number_of_licenses)
  end

  def ensure_valid_plan(plan)
    unless $pricing_plans.include?(plan)
      raise ArgumentError, "Invalid plan name: #{plan}"
    end
  end

  def ensure_valid_min_number_of_licenses(min_number_of_licenses)
    unless min_number_of_licenses.is_a?(Integer) && min_number_of_licenses >= 0
      raise ArgumentError, "Invalid min_number_of_licenses: #{min_number_of_licenses}"
    end
  end

  def ensure_valid_max_number_of_licenses(max_number_of_licenses)
    unless max_number_of_licenses.is_a?(Integer) || max_number_of_licenses == Float::INFINITY
      raise ArgumentError, "Invalid max_number_of_licenses: #{max_number_of_licenses}"
    end
  end

  def ensure_valid_price_per_license(price_per_license)
    unless price_per_license.is_a?(Numeric) && price_per_license >= 0
      raise ArgumentError, "Invalid price_per_license: #{price_per_license}"
    end
  end

  def ensure_max_is_higher_than_min(min_number_of_licenses, max_number_of_licenses)
    unless min_number_of_licenses <= max_number_of_licenses
      raise ArgumentError, "min_number_of_licenses should be less than or equal to max_number_of_licenses"
    end
  end

  def PricingModule.create (*args)
    begin
      (plan, min, max, price) = PricingModule.get_args(*args)
      price = PricingModule.new(plan, min, max, price)
    rescue Exception => e
      return "Error with pricing module: #{e.message}"
    else
      return price
    end
  end

  def PricingModule.get_args (*args)
    plan = args[0]
    min = args[1]
    case args.length
    when 3
      max = Float::INFINITY
      price = args[2]
    when 4
      max = args[2]
      price = args[3]
    else
      raise ArgumentError, "Invalid number of arguments"
    end
    return [plan, min, max, price]
  end

  def to_json(*args)
    hash_map =
      {
        "plan" => @plan,
        "min_number_of_licenses" => @min_number_of_licenses,

        "price_per_license" => @price_per_license
      }
    if @max_number_of_licenses != Float::INFINITY
      hash_map["max_number_of_licenses"] = @max_number_of_licenses
    end
    hash_map.to_json(*args)
  end

  def plan
    @plan
  end

  def price_per_license
    @price_per_license
  end

  def max_number_of_licenses
    @max_number_of_licenses
  end

  def min_number_of_licenses
    @min_number_of_licenses
  end
end
