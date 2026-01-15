class MatchesController < ApplicationController
  before_action :set_match, only: [:update, :destroy]

  # POST /matches
  def create
    skill = Skill.find(params.require(:match)[:skill_id])

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
      return render json: { error: "Not authorized" }, status: :unauthorized
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
