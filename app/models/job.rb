class Job
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :dag
  embeds_one :engine, class_name: "Engine", inverse_of: :job

  field :name, type: String
  field :description, type: String
  field :depends, type: Array, default: []
  field :ready, type: Boolean, default: false

  def ready!
    self.update(ready: true)
  end

  def update_from_config(config)
    self.ready = false
    self.depends = Array.wrap(config['depends']).compact
    self.description = config['description']
    self.engine = Engine.build_engine(config['engine'])
  end

  def full_name
    "#{dag.team.name}-#{dag.project.name}-#{dag.name}-#{name}"
  end

  def as_config
    {
      name: name,
      depends: depends,
      full_name: full_name,
      version: dag.version,
      engine: engine.as_config,
      image: "gcr.io/#{AppConfig.B2FLOW__GOOGLE__PROJECT_ID}/#{full_name}:#{dag.version}"
    }
  end
end