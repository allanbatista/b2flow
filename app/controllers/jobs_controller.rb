class DagsController < AuthenticatedController
  before_action :set_team, :ensure_team
  before_action :set_project, :ensure_project
  before_action :set_dag, :ensure_dag
  before_action :set_job, :ensure_dag

  def build_callback
    if params['success']
      @job.ready!

      if @dag.ready?
        @dag.publish
      end
    end
  end

  private
  def set_team
    @team = Team.find_by(name: params[:team_name])
  end

  def set_project
    @project = @team.projects.find_by(name: params[:project_name])
  end

  def ensure_team
    unless @team.present?
      return render json: { message: "team with name \"#{params[:team_name]}\" was not found. team is required" }, status: 422
    end
  end

  def ensure_project
    unless @project.present?
      return render json: { message: "project with name \"#{params[:project_name]}\" was not found. project is required" }, status: 422
    end
  end

  def set_dag
    @dag = @project.dags.find_by(name: params[:dag_name])
  end

  def ensure_dag
    unless @dag.present?
      return render json: { message: "dag with name \"#{params[:dag_name]}\" was not found. dag is required" }, status: 422
    end
  end

  def set_job
    @job = @dag.jobs.find_by(name: params[:job_name])
  end

  def ensure_dag
    unless @job.present?
      return render json: { message: "job with name \"#{params[:job_name]}\" was not found. job is required" }, status: 422
    end
  end

  def callback_params

  end
end
