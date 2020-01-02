class Engine
  include Mongoid::Document

  embedded_in :job, class_name: "Job", inverse_of: :engine

  def self.build_engine(config)
    engine =
    case config['type']
    when 'docker' then DockerEngine
    else raise "Engine #{config['type']} not found"
    end

    engine.build(config)
  end

  def as_config
    as_json.except("id", "_type").merge({"type" => self._type})
  end
end