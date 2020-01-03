class DagEnvironmentsController < ApplicationController
  before_action :set_team, :ensure_team
  before_action :set_project, :ensure_project
  before_action :set_dag, :ensure_dag

  def index
    if params[:complete] == "true"
      render json: @dag.complete_environments.map(&:to_api)
    else
      render json: @dag.environments.map(&:to_api)
    end
  end

  def update
    env = @dag.environments.find_or_initialize_by(name: params[:env_name])

    env.value = params[:value].to_s unless params[:value].nil?
    env.secret = params[:secret] unless params[:secret].nil?

    if env.save
        render json: env.to_api, status: 200
    else
      render json: env.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @dag.environments.find_by(name: params[:env_name]).try(:destroy!)

    render :nothing => true, status: 204
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
end
