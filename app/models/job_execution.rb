class JobExecution < ApplicationRecord
  belongs_to :job
  belongs_to :job_version

  validates :job, presence: true
  validates :job_version, presence: true
end
