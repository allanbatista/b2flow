class Manager
  def run
    loop do
      execute

      sleep_time = (Time.now + 1.minute) - Time.now

      if sleep_time > 0
        puts "Waiting next interation"
        sleep(sleep_time)
      end
    end
  end

  def execute
    now = Time.now
    puts now

    jobs = Job.where(enable: True, cron: nil)
    jobs = jobs.where("start_at <= ? or start_at is NULL", now)
    jobs = jobs.where("end_at <= ? or end_at is NULL", now)

    jobs.each do |job|
      JobPublisher.enqueue!(job) if should_enqueue?(job, now)
    end
  end

  ##
  # should valid only when next execute should be current time less 1 minute
  # and next execute should be equal current time
  def should_enqueue?(job, now)
    CronParser.new(job.cron).next(now.beginning_of_minute - 1.minute) == now.beginning_of_minute
  end
end