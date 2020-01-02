class DockerEngine < Engine
  field :cpu, type: Integer, default: 1
  field :memory, type: Integer, default: 4096

  def self.build(config)
    o = {
        'cpu' => 1,
        'memory' => 4096
    }.merge(config)
    DockerEngine.new(cpu: o['cpu'].to_i, memory: o['memory'].to_i)
  end
end