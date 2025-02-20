require 'minitest/reporters'

class CustomReporter < Minitest::Reporters::RubyMineReporter

  def record(test)
    super
    print "\b"
    if test.passed?
      puts "\e[32m✅ #{test.class_name} - #{test.name}\e[0m"
    elsif test.skipped?
      puts "\e[33m⚠️  #{test.class_name} - #{test.name} (Skipped)\e[0m"
    else
      puts "\e[31m❌ #{test.class_name} - #{test.name}\e[0m"
      puts "#{test.failure}"
    end
  end

end

# Activate the custom reporter
Minitest::Reporters.use! CustomReporter.new
