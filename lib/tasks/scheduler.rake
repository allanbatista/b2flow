namespace :scheduler do
  desc "This task monitoring and enqueue correct events from jobs that need to me executed"
  task manager: :environment do
    manager = Scheduler::Manager.new
    manager.run
  end
end
