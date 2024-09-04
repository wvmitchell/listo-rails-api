class ChecklistsController < ApplicationController
  def index
    # render checklists
    render json: current_user.owned_checklists
  end

  def show
    # render checklist with items included
    render json: current_user.owned_checklists.find(params[:id]),
           include: :items
  end
end
