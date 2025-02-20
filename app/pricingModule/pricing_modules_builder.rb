require_relative 'pricingModule/'

begin

  $pricing_plans = %w[aiMeeting enterprise]
  $pricing_periods = %w[monthly annually]

  $pricing_modules = [
    PricingModule.create("aiMeeting", 0, 9, 29),
    PricingModule.create("aiMeeting", 10, 50, 25),
    PricingModule.create("aiMeeting", 50, 15),
    PricingModule.create("enterprise", 10, 50, 55),
    PricingModule.create("enterprise", 50, 40),
  ].filter { |model| model.is_a?(PricingModule) }

end




