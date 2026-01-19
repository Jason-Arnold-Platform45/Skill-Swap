class MatchesController < ApplicationController
  before_action :set_match, only: [:update]

  # GET /matches
  def index
    matches = Match.for_user(current_user)

    render json: MatchSerializer.new(
      matches,
      include: [:skill, :requester, :provider]
    ).serializable_hash, status: :ok
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
      render json: MatchSerializer.new(
        @match,
        include: [:skill, :requester, :provider]
      ).serializable_hash, status: :ok
    else
      render json: { errors: @match.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_match
    @match = Match.find(params[:id])
  end

  def match_params
    params.require(:match).permit(:status)
  end
end
