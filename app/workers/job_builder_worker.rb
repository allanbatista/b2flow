class JobBuilderWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(job_id)
    job = Job.find(job_id)
    name = "builder-#{job.full_name}"
    Kube.jobs.delete_and_create(name, create_config(name, job))
  end

  def create_config(name, job)
    {
        "apiVersion": "batch/v1",
        "kind": "Job",
        "metadata": {
            "name": name
        },
        "spec": {
            "activeDeadlineSeconds": 3600,
            "backoffLimit": 0,
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
                    "volumes": [
                       {
                           "name": "dind-storage",
                           "emptyDir": {}
                       }
                    ],
                    "securityContext": {
                        "privileged": true
                    },
                    "volumeMounts": [
                        {
                            "name": "dind-storage",
                            "mountPath": "/var/lib/docker"
                        }
                    ],
                    "containers": [
                        {
                            "name": "executor-#{name}",
                            "image": "allanbatista/b2flow-engine-builder",
                            "resources": {
                               "limits": { "cpu" => "1", "memory" => "5Gi" },
                               "requests": { "cpu" => "1", "memory" => "5Gi" }
                            },
                            "env": [
                                {"name": "B2FLOW__DAG__JOB__NAME", "value": job.name.to_s },
                                {"name": "B2FLOW__IMAGE__TAG", "value": job.version.to_s },
                                {"name": "B2FLOW__IMAGE__NAME", "value": job.full_name },
                                {"name": "B2FLOW__STORAGE__TYPE", "value": "gcs" },
                                {"name": "B2FLOW__STORAGE__S3__ACCESS_KEY_ID", "value": AppConfig.B2FLOW__STORAGE__ACCESS_KEY_ID.to_s },
                                {"name": "B2FLOW__STORAGE__S3__SECRET_KEY_ID", "value": AppConfig.B2FLOW__STORAGE__SECRET_KEY_ID.to_s },
                                {"name": "B2FLOW__STORAGE__S3__REGION", "value": AppConfig.B2FLOW__STORAGE__REGION.to_s },
                                {"name": "B2FLOW__STORAGE__S3__BUCKET", "value": AppConfig.B2FLOW__STORAGE__BUCKET.to_s },
                                {"name": "B2FLOW__STORAGE__URI", "value": job.dag.source.url.to_s },
                                {"name": "B2FLOW__REGISTRY__GCP__KEYFILE", "value": AppConfig.B2FLOW__REGISTRY__GCP__KEYFILE.to_s },
                                {"name": "B2FLOW__BUILDER__CALLBACK__URI", "value": build_callback_uri(job).to_s },
                                {"name": "B2FLOW__GOOGLE__PROJECT_ID", "value": AppConfig.B2FLOW__GOOGLE__PROJECT_ID.to_s },
                                {"name": "DOCKER_TLS_CERTDIR", "value": ""}
                            ]
                        }
                    ]
                }
            }
        }
    }
  end

  def build_callback_uri(job)
    "#{AppConfig.B2FLOW__BASE__PROTOCOL}://#{AppConfig.B2FLOW__BASE__DOMAIN}/teams/#{job.dag.team.name}/projects/#{job.dag.project.name}/dags/#{job.dag.name}/jobs/#{job.name}/build_callback"
  end
end