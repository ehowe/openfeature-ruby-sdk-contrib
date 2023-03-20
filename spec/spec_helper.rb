# frozen_string_literal: true

require "json"
require "pry-byebug"
require "yaml"
require "open_feature/sdk/contrib"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |file| require file }

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
