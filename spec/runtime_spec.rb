RSpec.describe Asynr::Core do
  context "runtime" do
    it "creates and launches a job" do
      puts '-' * 30
      scheduler = Asynr.new
      scheduler.in 3, TestClass, {arg: :hello}
      scheduler.every 2, 2, TestClass, {args: :hello, entrypoint: :new, kill: true}
      scheduler.at (Time.now + 4), TestClass, {args: :hello, entrypoint: :_at, kill: true}
      scheduler.start
      
      expect($?.exitstatus == 0).to equal(true)
      puts '-' * 30
    end
  end
end
