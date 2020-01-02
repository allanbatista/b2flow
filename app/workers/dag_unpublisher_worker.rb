class DagUnpublisherWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'dags_unpublisher'

  def perform(dag_id)
    dag = Dag.find(dag_id)
    Kube.cronjobs.delete(dag.full_name) if Kube.cronjobs.find(dag.full_name).success?
  end
end