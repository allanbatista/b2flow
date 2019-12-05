class JobExecution < ApplicationRecord
  belongs_to :job
  belongs_to :job_version
  belongs_to :job_setting

  validates :job, presence: true
  validates :job_version, presence: true
  validates :job_setting, presence: true

  def self.create_by_job(job)
    create!(job: job, job_version: job.current_version, job_setting: job.current_setting)
  end

  def building!
    self.update!(status: "building")
  end

  def reserving!
    self.update!(status: "reserving")
  end

  def running!
    self.update!(status: "running")
  end

  def complete!
    self.update(status: "complete")
  end

  def fail!
    self.update(status: "fail")
  end
end
