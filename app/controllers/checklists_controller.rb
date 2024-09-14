class ChecklistsController < ApplicationController
  before_action :authenticate

  def index
    render json: {
             checklists: current_user.owned_checklists,
             shared_checklists: current_user.collaborated_checklists
           },
           include: :members
  end

  def show
    checklist = set_checklist

    if checklist
      render json: { checklist: checklist }, include: :items
    else
      render json: { message: "Checklist not found", status: :not_found }
    end
  end

  def create
    checklist = current_user.owned_checklists.create(checklist_params)
    render json: checklist
  end

  def update
    checklist = set_checklist
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
    checklist = current_user.owned_checklists.find(params[:checklist_id])

    shortcode = SecureRandom.hex(4)
    Rails.cache.write(shortcode, checklist.id, expires_in: 1.day)
    render json: { shortcode: shortcode }, status: :ok
  end

  def add_collaborator
    shortcode = params[:shortcode]
    checklist_id = Rails.cache.read(shortcode)
    checklist = Checklist.find(checklist_id)


    unless current_user.owned_checklists.include?(checklist) ||
             checklist.collaborators.include?(current_user)
      checklist.collaborators << current_user
      render json: { message: "Collaborator added", status: :ok }
    else
      render json: {
               message: "Collaborator not added",
               status: :unprocessable_entity
             }
    end
  end

  def remove_collaborator
    checklist = current_user.collaborated_checklists.find(params[:id])

    if checklist.collaborators.delete(current_user)
      render json: { message: "Collaborator removed", status: :ok }
    else
      render json: {
               message: "Collaborator not removed",
               status: :unprocessable_entity
             }
    end
  end

  private

  def set_checklist
    if current_user.owned_checklists.exists?(params[:id])
      @checklist = current_user.owned_checklists.find(params[:id])
    elsif current_user.collaborated_checklists.exists?(params[:id])
      @checklist = current_user.collaborated_checklists.find(params[:id])
    end
    @checklist
  end

  def checklist_params
    params.require(:checklist).permit(:title, :locked)
  end
end
