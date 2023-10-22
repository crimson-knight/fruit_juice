# frozen_string_literal: true

require "fruit_juice"

begin
  require 'redis'
rescue LoadError
  puts "redis is not available for this ruby version. Skipping tests for version #{RUBY_VERSION}"
  exit(0)
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
