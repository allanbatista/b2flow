class JobBuilderWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'jobs_builder'

  def perform(job_id)
    job = Job.find(job_id)
    Kube.jobs.create_or_replace("builder-#{job.full_name}", create_config(job))
  end

  def create_config(job)
    {
        "apiVersion": "batch/v1",
        "kind": "Job",
        "metadata": {
            "name": "dind"
        },
        "spec": {
            "template": {
                "spec": {
                    "restartPolicy": "Never",
                    "containers": [
                        {
                            "name": "docker-info",
                            "image": "allanbatista/b2flow-engine-builder",
                            "env": [
                                {"name": "B2FLOW__DAG__JOB__NAME", "value": job.name },
                                {"name": "B2FLOW__IMAGE__TAG", "value": job.version },
                                {"name": "B2FLOW__IMAGE__NAME", "value": job.full_name },
                                {"name": "B2FLOW__STORAGE__TYPE", "value": "gcs" },
                                {"name": "B2FLOW__STORAGE__S3__ACCESS_KEY_ID", "value": AppConfig.B2FLOW__STORAGE__ACCESS_KEY_ID },
                                {"name": "B2FLOW__STORAGE__S3__SECRET_KEY_ID", "value": AppConfig.B2FLOW__STORAGE__SECRET_KEY_ID },
                                {"name": "B2FLOW__STORAGE__S3__REGION", "value": AppConfig.B2FLOW__STORAGE__REGION },
                                {"name": "B2FLOW__STORAGE__S3__BUCKET", "value": AppConfig.B2FLOW__STORAGE__BUCKET },
                                {"name": "B2FLOW__STORAGE__URI", "value": job.dag.source.url },
                                {"name": "B2FLOW__REGISTRY__GCP__KEYFILE", "value": AppConfig.B2FLOW__REGISTRY__GCP__KEYFILE },
                                {"name": "B2FLOW__BUILDER__CALLBACK__URI", "value": build_callback_uri(job) }
                            ]
                        }
                    ]
                }
            },
            "backoffLimit": 4
        }
    }
  end

  def build_callback_uri(job)
    "#{AppConfig.B2FLOW__BASE__PROTOCOL}://#{AppConfig.B2FLOW__BASE__DOMAIN}/teams/#{job.dag.team.name}/projects/#{job.project.team.name}/dags/#{job.dag.name}/jobs/#{job.name}/build_callback"
  end
end