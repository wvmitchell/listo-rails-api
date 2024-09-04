class ChecklistsController < ApplicationController
  def index
    # render checklists
    render json: {
             checklists: current_user.owned_checklists,
             shared_checklists: current_user.collaborated_checklists
           },
           include: :collaborators
  end

  def show
    # render checklist with items included
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

  private

  def checklist_params
    params.require(:checklist).permit(:title, :locked)
  end
end
