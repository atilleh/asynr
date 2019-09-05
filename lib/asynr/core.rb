module Asynr
  # Core class exposes user-related methods 
  # to configure the scheduler jobs.
  class Core
    def initialize(params)
      @params = params
      @scheduler = {
        jobs: []
      }
    end

    # Create a new :in job
    # @param seconds [Int32] seconds to wait before running the job
    # @param action_class [Object] class to evaluate
    # @param arguments [Hash] optional arguments to pass to the job creator.
    def in(seconds, action_class, *arguments)
      @scheduler[:jobs].append(Job.new(
        type: :in,
        params: { seconds: seconds },
        action: action_class,
        arguments: arguments ||= nil
      ))
    end

    # Create a new :every job
    # @param seconds [Int32] seconds to wait between two occurences
    # @param delay [Int32] amount of seconds before running it the first time
    # @param action_class [Object] class to instantiate and execute.
    # @param arguments [Hash] optional argument to transmit to the entrypoint.
    def every(seconds, delay, action_class, *arguments)
      @scheduler[:jobs].append(Job.new(
        type: :every,
        params: { seconds: seconds, delay: delay},
        action: action_class,
        arguments: arguments ||= nil
      ))
    end

    # Create a new :at job
    # @param date_to [Object] Time object cursor to run the job.
    # @param action_class [Object] class to instantiate and execute.
    # @param arguments [hash] optional arguments to transmit to the entrypoint.
    def at(date_to, action_class, *arguments)
      @scheduler[:jobs].append(Job.new(
        type: :at,
        params: { date: date_to },
        action: action_class,
        arguments: arguments ||= nil
      ))
    end

    # Starts the scheduler.
    def start
      Scheduler.new(@scheduler)
    end

    # @return @scheduler [Hash] current scheduler instance
    def config
      @scheduler
    end

    # @return @scheduler [Hash] current job queue
    def jobs
      @scheduler[:jobs]
    end
  end
end
      