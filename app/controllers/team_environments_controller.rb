class TeamEnvironmentsController < ApplicationController
  before_action :set_team, :ensure_team

  def index
    render json: @team.environments.map(&:to_api)
  end

  def update
    env = @team.environments.find_or_initialize_by(name: params[:env_name])

    env.value = params[:value].to_s unless params[:value].nil?
    env.secret = params[:secret] unless params[:secret].nil?

    if env.save
      render json: env.to_api, status: 200
    else
      render json: env.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @team.environments.find_by(name: params[:env_name]).try(:destroy!)

    render :nothing => true, status: 204
  end

  private

  def set_team
    @team = Team.find_by(name: params[:team_name])
  end

  def ensure_team
    unless @team.present?
      return render json: { message: "team with name \"#{params[:team_name]}\" was not found. team is required" }, status: 422
    end
  end
end
