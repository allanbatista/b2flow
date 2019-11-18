class JobsController < AuthenticatedController
  before_action :set_team, :ensure_team
  before_action :set_project, :ensure_project
  before_action :set_job, only: [:show, :update, :destroy]

  # GET /jobs
  def index
    render json: @project.jobs.page(page).per(per_page).map(&:to_api)
  end

  # GET /jobs/1
  def show
    return render json: @job.to_api if @job.present?
    render json: { message: "job not found" }, status: 404
  end

  # POST /jobs
  def create
    @job = Job.new(job_params)
    @job.project = @project

    if @job.save
      render json: @job, status: :created, location: job_path(@team.name, @project.name, @job.name)
    else
      render json: @job.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /jobs/1
  def update
    if @job.update(job_params)
      render json: @job
    else
      render json: @job.errors, status: :unprocessable_entity
    end
  end

  private
    def set_team
      @team = Team.find_by_name(params[:team_name])
    end

    def set_project
      @project = @team.projects.find_by_name(params[:project_name])
    end

    def ensure_team
      unless @team.present?
        return render json: { message: "team with name \"#{params[:team_name]}\" was not found. team is required" }, status: 422
      end
    end

    def ensure_project
      unless @project.present?
        return render json: { message: "project is required" }, status: 422
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find_by_name(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def job_params
      params.permit(:name, :engine, :cron, :enable)
    end
end
