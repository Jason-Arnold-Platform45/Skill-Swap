class MatchesController < ApplicationController
  before_action :authenticate_user
  before_action :set_match, only: [:update, :destroy]

  def create
    skill = Skill.find(params[:skill_id])
    service = Matches::CreateService.new(requester: current_user, skill: skill)
    match = service.call

    render json: match, status: :created
  rescue Matches::CreateService::CannotMatchOwnSkillError => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue Matches::CreateService::SkillNotFoundError => e
    render json: { error: e.message }, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def update
    service = Matches::UpdateService.new(match: @match, user: current_user, status: match_params[:status])
    match = service.call

    render json: match, status: :ok
  rescue Matches::UpdateService::UnauthorizedError => e
    render json: { error: e.message }, status: :forbidden
  rescue Matches::UpdateService::InvalidStatusError => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def destroy
    service = Matches::DestroyService.new(match: @match, user: current_user)
    service.call

    render json: { message: "Match deleted successfully" }, status: :no_content
  rescue Matches::DestroyService::UnauthorizedError => e
    render json: { error: e.message }, status: :forbidden
  end

  private

  def set_match
    @match = Match.find_by(id: params[:id])
    head :not_found unless @match
  end

  def match_params
    params.require(:match).permit(:status)
  end
end