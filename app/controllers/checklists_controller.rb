class ChecklistsController < ApplicationController
  before_action :authenticate

  def index
    render json: {
             checklists: current_user.owned_checklists,
             shared_checklists: current_user.collaborated_checklists
           },
           include: :collaborators
  end

  def show
    render json: {
             checklist: current_user.owned_checklists.find(params[:id])
           },
           include: :items
  end

  def create
    checklist = current_user.owned_checklists.create(checklist_params)
    render json: checklist
  end

  def update
    checklist = current_user.owned_checklists.find(params[:id])
    checklist.update(checklist_params)
    render json: checklist
  end

  def destroy
    checklist = current_user.owned_checklists.find(params[:id])
    checklist.destroy!

    render json: { message: "Checklist deleted", status: :ok }
  rescue ActiveRecord::RecordNotFound
    render json: { message: "Checklist not found", status: :not_found }
  rescue ActiveRecord::RecordNotDestroyed => e
    render json: {
             message: "Checklist could not be deleted: #{e.message}",
             status: :unprocessable_entity
           }
  rescue StandardError => e
    render json: { message: e.message, status: :unprocessable_entity }
  end

  def share
    checklist = current_user.owned_checklists.find(params[:id])

    shortcode = SecureRandom.hex(7)
    Rails.cache.write(shortcode, checklist.id, expires_in: 1.day)
    render json: { shortcode: shortcode }, status: :ok
  end

  private

  def checklist_params
    params.require(:checklist).permit(:title, :locked)
  end
end
