class DagPublisherWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(dag_id)
    dag = Dag.find(dag_id)
    Kube.cronjobs.delete_and_create(dag.full_name, create_config(dag))
  end

  def create_config(dag)
    {
        "apiVersion": "batch/v1beta1",
        "kind": "CronJob",
        "metadata": {
            "name": dag.full_name
        },
        "spec": {
            "schedule": dag.cron,
            "suspend": !dag.enable,
            "jobTemplate": {
                "spec": {
                    "template": {
                        "spec": {
                            "restartPolicy": "Never",
                            "affinity": {
                                "nodeAffinity": {
                                    "requiredDuringSchedulingIgnoredDuringExecution": {
                                        "nodeSelectorTerms": [
                                            {
                                                "matchExpressions": [
                                                    {
                                                        "key": "flavor",
                                                        "operator": "In",
                                                        "values": [
                                                            "standard-1"
                                                        ]
                                                    }
                                                ]
                                            }
                                        ]
                                    }
                                }
                            },
                            "containers": [
                                {
                                    "name": "master",
                                    "image": "allanbatista/b2flow-manager",
                                    "env": [
                                        { "name": "B2FLOW__DAG__CONFIG", "value": dag.as_config.to_json },
                                        { "name": "B2FLOW__KUBERNETES__URI", "value": AppConfig.B2FLOW__KUBERNETES__URI },
                                        { "name": "B2FLOW__KUBERNETES__USERNAME", "value": AppConfig.B2FLOW__KUBERNETES__USERNAME },
                                        { "name": "B2FLOW__KUBERNETES__PASSWORD", "value": AppConfig.B2FLOW__KUBERNETES__PASSWORD }
                                    ]
                                }
                            ]
                        }
                    }
                }
            }
        }
    }
  end
end