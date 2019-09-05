RSpec.describe Asynr::Core do
  context "configuration" do
    it "creates a default scheduler" do
      scheduler = Asynr.new
      expect(scheduler.config.key? :jobs).to equal(true)
    end

    it "creates a new :in job" do
      scheduler = Asynr.new
      scheduler.in 3, self, {test: :arg}
      expect(scheduler.jobs.length == 1).to equal(true)
    end

    it "creates a new :every job" do
      scheduler = Asynr.new
      scheduler.every 3, 3, self, {test: :arg}
      expect(scheduler.jobs.length == 1).to equal(true)
    end

    it "stacks different jobs" do
      scheduler = Asynr.new
      scheduler.every 3, 3, self, {test: :arg}
      scheduler.in 2, self, {test: :arg2}
    end
  end
end