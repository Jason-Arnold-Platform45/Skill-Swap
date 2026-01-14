class SkillsController < ApplicationController
  skip_before_action :authenticate_user, only: [:index, :show]

  def index
    skills = Skill.where(deleted: nil)
    render json: skills
  end

  def show
    skill = Skill.find_by(id: params[:id], deleted: nil)

    if skill
      render json: skill
    else
      head :not_found
    end
  end

  def create
    skill = current_user.skills.build(skill_params)

    if skill.save
      render json: skill, status: :created
    else
      render json: { errors: skill.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def skill_params
    params.require(:skill).permit(:title, :description, :skill_type)
  end
end
