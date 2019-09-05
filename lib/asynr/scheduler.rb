module Asynr
  # Scheduler class creates new threads for any job
  # added to scheduler.
  # @see Core#start
  class Scheduler
    # Creates an empty array of threads
    # For each job, determines its type and create a thread based
    #  on it.
    # Finally, executes the threads.
    def initialize(scheduler)
      @threads = []
      scheduler[:jobs].each do |job|
        @threads.append(_in(job)) if job.type == :in
        @threads.append(_every(job)) if job.type == :every
        @threads.append(_at(job)) if job.type == :at
      end

      @threads.each do |thr|
        p thr.inspect
        thr.join
      end
    end

    protected
    # Creates a new :in job.
    # @param job [Object] job instance
    # @return thx [Thread] thread transition
    def _in(job)
      thx = Thread.new do
        job.declare_running
        sleep job.params[:seconds]
        job.action.send(job.entrypoint, job.arguments[0])
        job.update
        job.declare_finished
      end

      thx
    end

    # Creates a new :every job
    # Will sleep if a delay has been set.
    # Will be executed only once if kill parameter submitted.
    # @param job [Object] job instance
    # @return thx [Thread] thread transition
    def _every(job)
      thx = Thread.new do |thx|
        job.declare_running
        sleep job.params[:delay] ||= 0
        x = true

        while x == true
          job.action.send(job.entrypoint, job.arguments[0])
          job.update

          if job.arguments[0][:kill]
            puts "Job will sleep."
            x = false
          end

          sleep job.params[:seconds]
        end
      end

      thx
    end

    # Creates a new :at job
    # Will be killed if kill argument specified.
    # By default, execute the same job every day.
    # @param job [Object] job object
    # @return thx [Thread] thread transition
    def _at(job)
      thx = Thread.new do |thx|
        job.declare_scheduled

        x = false

        while x == false
          if Time.now.to_i == job.params[:date].to_i
            job.declare_running
            job.action.send(job.entrypoint, job.arguments[0])
            job.update
            job.declare_finished

            if job.arguments[0][:kill]
              x = true
            end

            job.params[:date] = Time.now + 86400
          else
            sleep 1
          end
        end
      end

      thx
    end

  end
end