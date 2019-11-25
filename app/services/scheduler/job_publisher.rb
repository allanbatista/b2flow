module Scheduler
  class JobPublisher
    attr_reader :publisher

    def initialize(publisher)
      @publisher = publisher
    end

    def publish(job)
      execution = JobExecution.create_by_job(job)
      execution.update(enqueued_at: DateTime.now)
      message = execution.as_message
      publisher.publish(message.to_json)
      Rails.logger.debug(message)
    end
  end
end
