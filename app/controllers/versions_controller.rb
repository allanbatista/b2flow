class VersionsController < AuthenticatedController
  before_action :set_team, :ensure_team
  before_action :set_project, :ensure_project
  before_action :set_job, :ensure_job

  # GET /versions
  def index
    render json: @job.versions.order(:created_at => :desc).page(page).per(per_page).map(&:to_api)
  end

  # POST /versions
  def create
    @version = @job.versions.new.tap do |version|
      version.source.attach(params[:source])
    end

    if @version.save
      render json: @version.to_api, status: :created, location: version_path(@team.name, @project.name, @job.name, @version)
    else
      render json: @version.errors, status: :unprocessable_entity
    end
  end

  private

  def set_team
    @team = Team.find_by_name(params[:team_name])
  end

  def set_project
    @project = @team.projects.find_by_name(params[:project_name])
  end

  def set_job
    @job = @project.jobs.find_by_name(params[:job_name])
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

  def ensure_job
    unless @job.present?
      return render json: { message: "job with name \"#{params[:job_name]}\" was not found. job is required" }, status: 422
    end
  end
end

