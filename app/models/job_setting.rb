class JobSetting < ApplicationRecord
  belongs_to :job

  validates :job, presence: true

  def to_api
    as_json(only: [:id, :job_id, :settings])
  end
end
