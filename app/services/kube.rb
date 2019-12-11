class Kube
  include Singleton
  attr_reader :connection

  def initialize
    @connection = Faraday.new(AppConfig.B2FLOW__KUBERNETES__URI, {ssl: { verify: false }, headers: { 'content-type': 'application/json' }} )
    @connection.basic_auth(AppConfig.B2FLOW__KUBERNETES__USERNAME, AppConfig.B2FLOW__KUBERNETES__PASSWORD)
  end

  def client
    ApiSdl.new(connection)
  end

  def cronjobs
    @cronjobs ||= KubeResource.new(client,"/apis/batch/v1beta1", "default", "cronjobs")
  end

  def pods
    @pods ||= KubeResource.new(client,"/api/v1", "default", "pods")
  end
end

