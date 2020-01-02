class DagPublisherWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'dags_publisher'

  def perform(dag_id)
    dag = Dag.find(dag_id)
    Kube.cronjobs.create_or_replace(dag.full_name, create_config(dag))
  end

  def create_config(dag)
    {
        "apiVersion": "batch/v1beta1",
        "kind": "CronJob",
        "metadata": {
            "name": dag.full_name
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
                                    "image": "allanbatista/b2flow-manager",
                                    "env": [
                                        { "name": "B2FLOW__DAG__CONFIG", "value": dag.as_config.to_json },
                                        { "name": "B2FLOW__STORAGE__PATH", "value": dag.source.url },
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
  end
end