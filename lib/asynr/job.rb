module Asynr
  class Job
    def initialize(job_descriptor)
      @job = job_descriptor
      @job[:metas] = {
        created_at: Time.now,
        created_at_timestamp: Time.now.to_i,
        updated_at: Time.now,
        status: :awaiting
      }

      if job_descriptor[:arguments][0].key? :entrypoint
        @job[:entrypoint] = job_descriptor[:arguments][0][:entrypoint]
      else
        @job[:entrypoint] = :_entrypoint
      end
    end

    def type
      @job[:type]
    end

    def params
      @job[:params]
    end

    def arguments
      @job[:arguments]
    end

    def action
      @job[:action]
    end

    def metas
      @job[:metas]
    end

    def update
      @job[:metas][:updated_at] = Time.now
    end

    def declare_running
      @job[:metas][:status] = :running
    end

    def declare_finished
      @job[:metas][:status] = :finished
    end

    def declare_scheduled
      @job[:metas][:status] = :scheduled
    end

    def entrypoint
      @job[:entrypoint]
    end
  end
end
