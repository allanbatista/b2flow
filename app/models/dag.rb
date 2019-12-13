class Dag
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  belongs_to :team
  belongs_to :project

  field :name, type: String
  field :cron, type: String
  field :config, type: Hash, default: {}
  field :enable, type: Boolean, default: false

  has_mongoid_attached_file :source

  validates_attachment :source, content_type: { content_type: 'application/zip' }
  validates :name, presence: true, uniqueness: { scope: [:team_id, :project_id] }
  validates :enable, presence: true
  # validates :cron, allow_blank: true, format: { with: /\A((\*|\d+((\/|\-){0,1}(\d+))*)\s*){5}\Z/ }

  after_save :integrate_kubernetes

  def to_api
    as_json(only: [:_id, :name, :enable, :cron, :config, :team_id, :project_id], methods: [:source_url])
  end

  def source_url
    source.url
  end

  def full_name
    "#{team.name}-#{project.name}-#{name}"
  end

  def integrate_kubernetes
    cronjob = {
      "apiVersion": "batch/v1beta1",
      "kind": "CronJob",
      "metadata": {
        "name": full_name
      },
      "spec": {
        "schedule": cron,
        "suspend": !enable,
        "successfulJobsHistoryLimit": 10,
        "failedJobsHistoryLimit": 10,
        "concurrencyPolicy": "Forbid",
        "jobTemplate": {
          "spec": {
            "template": {
              "spec": {
                "containers": [
                  {
                    "name": "master",
                    "image": "debian:stable-slim",
                    "env": [
                      { "name": "B2FLOW__DAG__CONFIG", "value": config.to_json },
                      { "name": "B2FLOW__STORAGE_PATH", "value": source.path },
                      { "name": "B2FLOW__STORAGE__TYPE", "value": AppConfig.B2FLOW__STORAGE__TYPE},
                      { "name": "B2FLOW__STORAGE__HOST_NAME", "value": AppConfig.B2FLOW__STORAGE__HOST_NAME },
                      { "name": "B2FLOW__STORAGE__ACCESS_KEY_ID", "value": AppConfig.B2FLOW__STORAGE__ACCESS_KEY_ID },
                      { "name": "B2FLOW__STORAGE__SECRET_KEY_ID", "value": AppConfig.B2FLOW__STORAGE__SECRET_KEY_ID },
                      { "name": "B2FLOW__STORAGE__REGION", "value": AppConfig.B2FLOW__STORAGE__REGION },
                      { "name": "B2FLOW__STORAGE__BUCKET", "value": AppConfig.B2FLOW__STORAGE__BUCKET },
                      { "name": "B2FLOW__STORAGE__PREFIX", "value": AppConfig.B2FLOW__STORAGE__PREFIX },
                      { "name": "B2FLOW__KUBERNETES__URI", "value": AppConfig.B2FLOW__KUBERNETES__URI },
                      { "name": "B2FLOW__KUBERNETES__VERSION", "value": AppConfig.B2FLOW__KUBERNETES__VERSION },
                      { "name": "B2FLOW__KUBERNETES__USERNAME", "value": AppConfig.B2FLOW__KUBERNETES__USERNAME },
                      { "name": "B2FLOW__KUBERNETES__PASSWORD", "value": AppConfig.B2FLOW__KUBERNETES__PASSWORD }
                    ],
                    "args": [
                        "/bin/sh",
                        "-c",
                        "date; echo Hello from the Kubernetes cluster"
                    ]
                  }
                ],
                "restartPolicy": "OnFailure"
              }
            }
          }
        }
      }
    }

    if cron.present?
      Kube.cronjobs.create_or_replace(full_name, cronjob)
    else
      Kube.cronjobs.delete(full_name) if Kube.cronjobs.find(full_name).success?
    end
  end
end
