class TeamsController < AuthenticatedController
  before_action :set_team, only: [:show, :update, :destroy]

  # GET /teams
  def index
    render json: Team.page(page).per(per_page).map(&:to_api)
  end

  # GET /teams/1
  def show
    render json: @team.to_api
  end

  # POST /teams
  def create
    @team = Team.new(team_params)

    if @team.save
      render json: @team.to_api, status: :created, location: team_path(@team.name)
    else
      render json: @team.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /teams/1
  def update
    if @team.update(team_params)
      render json: @team.to_api
    else
      render json: @team.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find_by(name: params[:team_name])
    end

    # Only allow a trusted parameter "white list" through.
    def team_params
      params.permit(:name)
    end
end
