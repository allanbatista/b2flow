class Job
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :dag
  embeds_one :engine, class_name: "Engine", inverse_of: :job

  field :name, type: String
  field :description, type: String
  field :depends, type: Array, default: []
  field :version, type: Integer
  field :ready, type: Boolean, default: false

  before_save do
    self.version = Time.now.to_i
    self.ready = false
  end
  after_save -> { JobBuilderWorker.perform_async(self.id.to_s) }

  def ready!
    self.ready = true
  end

  def update_from_config(config)
    self.depends = Array.wrap(config['depends']).compact
    self.description = config['description']
    self.engine = Engine.build_engine(config['engine'])
  end

  def full_name
    "#{dag.team.name}_#{dag.project.name}_#{dag.name}_#{name}"
  end

  def as_config
    {
      name: name,
      depends: depends,
      full_name: full_name,
      version: version,
      engine: engine.as_config
    }
  end
end