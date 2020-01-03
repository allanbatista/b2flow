class Kube
  include Singleton
  attr_reader :connection, :client

  def initialize
    @connection = Faraday.new(AppConfig.B2FLOW__KUBERNETES__URI, {ssl: {verify: false }, headers: {'content-type': 'application/json' }} )

    if AppConfig.B2FLOW__KUBERNETES__USERNAME.present? and AppConfig.B2FLOW__KUBERNETES__PASSWORD.present?
      @connection.basic_auth(AppConfig.B2FLOW__KUBERNETES__USERNAME, AppConfig.B2FLOW__KUBERNETES__PASSWORD)
    end

    @client = ApiClient.new(@connection)
  end

  class << self
    def cronjobs
      self.instance.cronjobs
    end

    def pods
      self.instance.pods
    end

    def jobs
      self.instance.jobs
    end
  end

  def cronjobs
    @cronjobs ||= KubeResource.new(client,"/apis/batch/v1beta1", "default", "cronjobs")
  end

  def pods
    @pods ||= KubeResource.new(client,"/api/v1", "default", "pods")
  end

  def jobs
    @jobs ||= KubeResource.new(client,"/apis/batch/v1", "default", "jobs")
  end
end