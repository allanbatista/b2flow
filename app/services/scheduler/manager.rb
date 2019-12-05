module Scheduler
  class Manager
    attr_reader :publisher

    def initialize
      @publisher = Broaker::RabbitPublisher.new(AppConfig.B2FLOW__BROAKER__QUEUE__JOBS)
    end

    def run
      Rails.logger.info("start executing")

      loop do
        execute(Time.now)

        sleep_time = (Time.now + 1.minute) - Time.now

        if sleep_time > 0
          Rails.logger.info "waiting next iteration. sleeping #{sleep_time.round(2)}s"
          sleep(sleep_time)
        end
      end
    end

    def execute(now)
      Rails.logger.info "executing #{now}"
      jobs = executable_jobs(now)

      Rails.logger.info("nothing to execute") if jobs.empty?

      jobs.each do |job|
        publish(job) if should_enqueue?(job, now)
      rescue => e
        Rails.logger.error([job, e])
      end
    end

    def executable_jobs(now)
      jobs = Job.where(enable: true).where("cron is not NULL")
      jobs = jobs.where("start_at <= ? or start_at is NULL", now)
      jobs.where("end_at > ? or end_at is NULL", now)
    end

    ##
    # should valid only when next execute should be current time less 1 minute
    # and next execute should be equal current time
    def should_enqueue?(job, now)
      cron_validate = CronParser.new(job.cron).next(now.beginning_of_minute - 1.minute) == now.beginning_of_minute
      cron_validate && !is_running?(job)
    rescue => e
      Rails.logger.error(e)
    end

    ##
    # this check if has any job in a state running
    def is_running?(job)
      job.executions.where(status: %w(running enqueued)).limit(1).first.present?
    end

    def publish(job)
      execution = JobExecution.create_by_job(job)
      execution.update(enqueued_at: DateTime.now)
      publisher.publish({job_execution_id: execution.id})
      Rails.logger.debug(message)
    end
  end
end