class JobVersion < ApplicationRecord
  has_one_attached :source

  belongs_to :job

  validates :job, presence: true
  validates :version, presence: true, uniqueness: { scope: [:job_id] }
  validates :source, blob: { content_type: ['application/zip'] }

  before_save :ensure_job_not_persisted!
  before_create :set_version!

  protected

  def set_version!
    self['version'] = job.versions.count + 1
  end

  def ensure_job_not_persisted!
    raise "not permit update" if self.persisted?
  end
end
