class SkillsController < ApplicationController
  skip_before_action :authenticate_user, only: %i[index show]

  def index
    skills = Skill.where(deleted: nil)
    render json: skills.map { |skill| SkillSerializer.new(skill).as_json }
  end

  def show
    skill = Skill.find_by(id: params[:id], deleted: nil)
    return head :not_found unless skill

    render json: SkillSerializer.new(skill).as_json
  end
end
