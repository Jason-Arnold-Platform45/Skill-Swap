class SkillsController < ApplicationController
  before_action :set_skill, only: [:show]

  def index
    skills = Skill.where(deleted: nil).order(created_at: :desc)

    render json: skills.map { |skill|
      SkillSerializer.new(skill).as_json
    }
  end

  def show
    render json: SkillSerializer.new(@skill).as_json
  end

  private

  def set_skill
    @skill = Skill.where(deleted: nil).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Skill not found" }, status: :not_found
  end
end
