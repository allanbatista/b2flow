class Project
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :team
  has_many :dags
  has_many :environments, class_name: "ProjectEnvironment"

  field :name, type: String

  validates :name, presence: true, uniqueness: { scope: [:team_id] }
  validates :team, presence: true

  def complete_environments
    envs = {}

    team.environments.each do |env|
      envs[env.name] = env
    end

    environments.each do |env|
      envs[env.name] = env
    end

    envs.values
  end

  def to_api
    as_json(only: [:_id, :name, :team_id, :created_at, :updated_at])
  end

  def name=(new_name)
    self['name'] = new_name.downcase.strip if new_name.present?
  end
end
