class ProjectsController < AuthenticatedController
  before_action :set_team, :ensure_team
  before_action :set_project, only: [:show, :update, :destroy]

  # GET /projects
  def index
    render json: @team.projects.page(page).per(per_page).map(&:to_api)
  end

  # GET /projects/1
  def show
    render json: @project
  end

  # POST /projects
  def create
    @project = Project.new(project_params)
    @project.team = @team


    if @project.save
      render json: @project.to_api, status: :created, location: project_path(@team.name, @project.name)
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      render json: @project.to_api
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  private
    def set_team
      @team = Team.find_by(name: params[:team_name])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = @team.projects.find_by(name: params[:project_name])
    end

    # Only allow a trusted parameter "white list" through.
    def project_params
      params.permit(:name)
    end

    def ensure_team
      unless @team.present?
        return render json: { message: "team with name \"#{params[:team_name]}\" was not found. team is required" }, status: 422
      end
    end
end
