class Prices

  def initialize(monthly, annually)
    ensure_valid_arguments(monthly, annually)
    @monthly = monthly
    @annually = annually
  end

  def monthly
    @monthly
  end

  def annually
    @annually
  end

  def ensure_valid_arguments(monthly, annually)
    ensure_valid_monthly(monthly)
    ensure_valid_annually(annually, monthly)
  end

  def ensure_valid_monthly(monthly)
    unless monthly.is_a?(Numeric) && monthly >= 0
      raise ArgumentError, "Invalid monthly price: #{monthly}"
    end
  end

  def ensure_valid_annually(annually, monthly)
    unless annually.is_a?(Numeric) && annually >= monthly
      raise ArgumentError, "Invalid annually price: #{annually}"
    end
  end

  def to_json(*args)
    hash_map =
      { "prices":
          { "monthly" => @monthly,
            "annually" => @annually
          } }
    hash_map.to_json(*args)
  end
end
