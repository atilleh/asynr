require "bundler/setup"
require "asynr"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

class TestClass
  def initialize(*args)
    validate
  end

  def validate
    self.display
  end

  def self._entrypoint(*args)
    self.display
  end

  def self._alternative(*args)
    self.display
  end

  def self._at(*args)
    self.display
  end
end