class MatchesController < ApplicationController
  before_action :authenticate_user
  before_action :set_match, only: [:update, :destroy]

  # GET /matches
  def index
    matches = Match.for_user(current_user)

    render json: MatchSerializer
      .new(matches, include: [:skill, :requester, :provider])
      .serializable_hash,
      status: :ok
  end

  # POST /matches
  def create
    skill = Skill.find(match_create_params[:skill_id])

    if skill.user == current_user
      return render json: { error: "You cannot request your own skill" },
                    status: :unprocessable_entity
    end

    match = Match.find_or_initialize_by(
      requester: current_user,
      skill: skill
    )

    if match.persisted?
      return render json: { error: "You already requested this skill" },
                    status: :unprocessable_entity
    end

    match.provider = skill.user
    match.status = "pending"

    if match.save
      render json: MatchSerializer
        .new(match, include: [:skill, :requester, :provider])
        .serializable_hash,
        status: :created
    else
      render json: { errors: match.errors.full_messages },
            status: :unprocessable_entity
    end
  end

  # PATCH /matches/:id
  def update
    unless @match.provider == current_user
      return render json: { error: "Only skill owner can respond" }, status: :unauthorized
    end

    unless %w[accepted rejected].include?(match_params[:status])
      return render json: { error: "Invalid status" }, status: :unprocessable_entity
    end

    if @match.update(match_params)
      render json: MatchSerializer
        .new(@match, include: [:skill, :requester, :provider])
        .serializable_hash,
        status: :ok
    else
      render json: { errors: @match.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /matches/:id
  def destroy
    unless [@match.requester, @match.provider].include?(current_user)
      return render json: { error: "Not authorized" }, status: :unauthorized
    end

    @match.destroy
    render json: { message: "Match cancelled" }, status: :ok
  end

  private

  def set_match
    @match = Match.find(params[:id])
  end

  def match_params
    params.require(:match).permit(:status)
  end

  def match_create_params
    params.require(:match).permit(:skill_id)
  end
end
