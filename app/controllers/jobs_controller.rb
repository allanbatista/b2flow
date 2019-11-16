class JobsController < AuthenticatedController
  before_action :set_job, only: [:show, :update, :destroy]

  # GET /jobs
  def index
    render json: Job.page(page).per(per_page).map(&:to_api)
  end

  # GET /jobs/1
  def show
    render json: @job.to_api
  end

  # POST /jobs
  def create
    @job = Job.new(job_params)

    if @job.save
      render json: @job, status: :created, location: @job
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
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def job_params
      params.require(:job).permit(:name, :team_id, :project_id, :engine, :scheduler)
    end
end
