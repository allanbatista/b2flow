class Dag
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  belongs_to :team
  belongs_to :project

  has_many :jobs
  has_many :environments, class_name: "DagEnvironment"

  field :name, type: String
  field :cron, type: String
  field :enable, type: Boolean, default: false

  has_mongoid_attached_file :source

  validates_attachment :source, content_type: { content_type: 'application/zip' }
  validates :name, presence: true, uniqueness: { scope: [:team_id, :project_id] }
  validates :enable, presence: true

  after_save do
    DagWorker.perform_async(self.id.to_s) if changed? and enable
  end

  def to_api
    as_json(only: [:_id, :name, :enable, :cron, :team_id, :project_id], methods: [:source_url, :ready])
  end

  def complete_environments
    envs = {}

    project.complete_environments.each do |env|
      envs[env.name] = env
    end

    environments.each do |env|
      envs[env.name] = env
    end

    envs.values
  end

  def source_url
    source.url
  end

  def storage_path
    if AppConfig.B2FLOW__STORAGE__TYPE == 'GCS'
      "gs://#{AppConfig.B2FLOW__STORAGE__BUCKET}/#{source.path}"
    elsif AppConfig.B2FLOW__STORAGE__TYPE == 'S3'
      "g3://#{AppConfig.B2FLOW__STORAGE__BUCKET}/#{source.path}"
    else
      source.path
    end
  end

  def full_name
    "#{team.name}-#{project.name}-#{name}"
  end

  def publish
    DagPublisherWorker.perform_async(self.id.to_s)
  end

  def unpublish
    DagUnpublisherWorker.perform_async(self.id.to_s)
  end

  def as_config
    {
        name: name,
        full_name: full_name,
        team: team.name,
        project: project.name,
        jobs: jobs.map(&:as_config)
    }
  end

  def ready
    jobs.map(&:ready).all?
  end
end
