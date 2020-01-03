class DockerEngine < Engine
  field :flavor, type: String, default: 'standard-1'

  def self.build(config)
    o = { 'flavor' => 'standard-1' }.merge(config)
    DockerEngine.new(flavor: o['flavor'])
  end
end