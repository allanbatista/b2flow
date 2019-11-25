class SettingsController < AuthenticatedController
  before_action :set_team, :ensure_team
  before_action :set_project, :ensure_project
  before_action :set_job, :ensure_job

  # GET /settings
  def index
    render json: @job.settings.order(:created_at => :desc).page(page).per(per_page).map(&:to_api)
  end

  # POST /settings
  def create
    @setting = @job.settings.new(settings_params)

    if @setting.save
      render json: @setting.to_api, status: :created, location: setting_path(@team.name, @project.name, @job.name, @setting)
    else
      render json: @setting.errors, status: :unprocessable_entity
    end
  end

  private

  def settings_params
    params.permit(:settings => {})
  end

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

