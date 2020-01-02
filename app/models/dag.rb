class Dag
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  belongs_to :team
  belongs_to :project

  has_many :jobs

  field :name, type: String
  field :cron, type: String
  field :config, type: Hash, default: {}
  field :enable, type: Boolean, default: false

  has_mongoid_attached_file :source

  validates_attachment :source, content_type: { content_type: 'application/zip' }
  validates :name, presence: true, uniqueness: { scope: [:team_id, :project_id] }
  validates :enable, presence: true

  after_save -> { DagWorker.perform_async(self.id.to_s) }

  def to_api
    as_json(only: [:_id, :name, :enable, :cron, :config, :team_id, :project_id], methods: [:source_url])
  end

  def source_url
    source.url
  end

  def full_name
    "#{team.name}_#{project.name}_#{name}"
  end

  def publish
    DagPublishWorker.perform_async(self.id.to_s) if enable and crontab.present?
  end

  def as_config
    {
        name: name,
        config: team.config.merge(project.config).merge(config),
        team: team.name,
        project: project.name,
        jobs: jobs.map(&:as_config)
    }
  end
end
