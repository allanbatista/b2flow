class DagsController < AuthenticatedController
  before_action :set_team, :ensure_team
  before_action :set_project, :ensure_project
  before_action :set_dag, only: [:show, :update, :destroy]

  # GET /dags
  def index
    render json: @project.dags.page(page).per(per_page).map(&:to_api)
  end

  # GET /dags/1
  def show
    return render json: @dag.to_api if @dag.present?
    render json: { message: "job not found" }, status: 404
  end

  # POST /dags
  def create
    dag = Dag.new(dag_params)
    dag.project = @project
    dag.team = @team
    dag.source = StringIO.new(Base64.decode64(params[:source])) if params[:source]

    if dag.save
      render json: dag.to_api, status: :created, location: dag_path(@team.name, @project.name, dag.name)
    else
      render json: dag.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /dags/1
  def update
    @dag.source = StringIO.new(Base64.decode64(params[:source])) if params[:source]
    if @dag.update(dag_params_update)
      render json: @dag.to_api
    else
      render json: @dag.errors, status: :unprocessable_entity
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

    # Use callbacks to share common setup or constraints between actions.
    def set_dag
      @dag = @project.dags.find_by(name: params[:dag_name])
    end

    # Only allow a trusted parameter "white list" through.
    def dag_params
      params.permit(:name, :cron, :enable, :config => {})
    end

    def dag_params_update
      params.permit(:cron, :enable, :config => {})
    end
end
