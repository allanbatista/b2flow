namespace :scheduler do
  desc "This task monitoring and enqueue correct events from jobs that need to me executed"
  task manager: :environment do
    Rails.logger.info('Start Scheduler')
    Scheduler::Manager.new.run
  end

  desc "Execute each task"
  task executor: :environment do
    Rails.logger.info('Start Executor')
    Scheduler::Executor.new.run
  end
end
