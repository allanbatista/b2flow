class Job < ApplicationRecord
  belongs_to :project
  has_many :versions, class_name: "JobVersion"

  validates :name, presence: true, uniqueness: { scope: [:project_id] }
  validates :project, presence: true
  validates :enable, presence: true
  validates :engine, presence: true, inclusion: { in: %w(docker),  message: "%{value} is not a valid engine" }
  validates :cron, allow_blank: true , format: { with: Regexp.new('\A((\*|\d+((\/|\-){0,1}(\d+))*)\s*){5}\z') }

  def to_api
    as_json(only: [:id, :name, :project_id, :engine, :cron, :enable, :created_at, :updated_at])
  end

  def name=(new_name)
    self['name'] = new_name.downcase.strip if new_name.present?
  end

  def cron=(new_cron)
    if new_cron.present?
      self['cron'] = new_cron.downcase.gsub(/\s+/, " ").strip
    else
      super
    end
  end
end
