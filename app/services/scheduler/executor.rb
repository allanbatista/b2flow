module Scheduler
  class Executor
    attr_reader :consumer

    def initialize
      @consumer = Broaker::RabbitConsumer.new(AppConfig.B2FLOW__BROAKER__QUEUE__JOBS, JSON)
    end

    def run
      @consumer.pooling do |message|
        je = JobExecution.find_by(message["job_execution_id"])
        je.reserving!

        # start configure cluster

        je.running!
      end
    end
  end
end
