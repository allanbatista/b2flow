require 'zip'

class DagWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(dag_id)
    dag = Dag.find(dag_id)
    build_jobs(dag, extract_yaml_config(dag))
  end

  def extract_yaml_config(dag)
    io = StringIO.new(Paperclip.io_adapters.for(dag.source).read)

    yaml = nil

    Zip::File.open_buffer(io) do |zip|
      zip.each do |entry|
        if entry.name == "b2flow.yml"
          yaml = entry.get_input_stream.read
          break
        end
      end
    end

    return yaml
  end

  def build_jobs(dag, yaml)
    data = YAML.load(yaml)
    jobs = data['dag']['config']['jobs']

    jobs.keys.each do |key|
      job = dag.jobs.find_by(name: key) || dag.jobs.new(name: key)
      job.update_from_config(jobs[key])
      job.save
    end

    dag.jobs.where(:name.nin => jobs.keys).map(&:delete)
  end
end