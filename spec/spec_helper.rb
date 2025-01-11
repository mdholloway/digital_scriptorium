# frozen_string_literal: true

require 'digital_scriptorium'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def fixture_path(file)
  File.join(__dir__, 'fixtures', file)
end

def read_fixture(file)
  File.read(fixture_path(file))
end
