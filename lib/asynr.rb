require "asynr/version"
require "asynr/core"
require "asynr/job"
require "asynr/scheduler"

module Asynr

  # Create a new scheduler
  # @param params [Hash] default option to create a scheduler.
  # @return self [Object] scheduler object from #Core
  def self.new(params={})
    Core.new(params)
  end

  class Error < StandardError; end
end
