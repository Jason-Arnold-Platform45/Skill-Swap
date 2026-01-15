class SkillsController < ApplicationController
  skip_before_action :authenticate_user, only: [:index, :show]
  before_action :set_skill, only: [:show, :update, :destroy]

  def index
    skills = Skill.includes(:user, :matches).where(deleted: nil)
    render json: skills.map { |skill| SkillSerializer.new(skill).as_json }
  end

  def show
    render json: SkillSerializer.new(@skill).as_json
  end

  def create
    skill = current_user.skills.build(skill_params)

    if skill.save
      render json: SkillSerializer.new(skill).as_json, status: :created
    else
      render json: { errors: skill.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authorize_skill_owner!
    return if performed?

    if @skill.update(skill_params)
      render json: SkillSerializer.new(@skill).as_json, status: :ok
    else
      render json: { errors: @skill.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize_skill_owner!
    return if performed?

    @skill.destroy
    head :no_content
  end

  private

  def set_skill
    @skill = Skill.find_by(id: params[:id])
    head :not_found unless @skill
  end

  def authorize_skill_owner!
    render json: { error: "Unauthorized" }, status: :forbidden unless @skill.user_id == current_user.id
  end

  def skill_params
    params.require(:skill).permit(:title, :description, :skill_type)
  end
end
