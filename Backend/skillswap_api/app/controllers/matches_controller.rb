class MatchesController < ApplicationController
  before_action :authenticate_user
  before_action :set_match, only: [:update, :destroy]

  # GET /matches
  def index
    matches = Match
      .includes(:skill, :requester, :provider)
      .where(
        "requester_id = :user_id OR provider_id = :user_id",
        user_id: current_user.id
      )

    render json: matches.map { |match|
      {
        id: match.id,
        status: match.status,
        skill: {
          id: match.skill.id,
          title: match.skill.title
        },
        requester: {
          id: match.requester.id,
          username: match.requester.username
        },
        provider: {
          id: match.provider.id,
          username: match.provider.username
        },
        created_at: match.created_at
      }
    }
  end

  # POST /matches
  def create
    skill = Skill.find(params.require(:match).permit(:skill_id)[:skill_id])

    if skill.user == current_user
      return render json: { error: "You cannot request your own skill" }, status: :unprocessable_entity
    end

    match = Match.new(
      skill: skill,
      requester: current_user,
      provider: skill.user,
      status: "pending"
    )

    if match.save
      render json: match, status: :created
    else
      render json: { errors: match.errors.full_messages }, status: :unprocessable_entity
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
      render json: @match, status: :ok
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
end
