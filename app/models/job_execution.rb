class JobExecution < ApplicationRecord
  belongs_to :job
  belongs_to :job_version
  belongs_to :job_setting

  validates :job, presence: true
  validates :job_version, presence: true
  validates :job_setting, presence: true

  def as_message
    as_json(include: [ :job, :job_version, :job_setting ])
  end

  def self.create_by_job(job)
    create!(job: job, job_version: job.current_version, job_setting: job.current_setting)
  end
end
