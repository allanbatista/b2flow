class JobVersion < ApplicationRecord
  has_one_attached :source

  belongs_to :job

  validates :job, presence: true
  validates :source, presence: true, blob: { content_type: ['application/zip'] }

  def to_api
    as_json(only: [:id, :job_id, :settings], :methods => [:source_url])
  end

  def source_url
    Rails.application.routes.url_helpers.rails_blob_url(source)
  end
end
