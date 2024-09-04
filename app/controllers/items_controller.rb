class ItemsController < ApplicationController
  before_action :set_checklist

  def index
    render json: @checklist.items
  end

  def create
    item = @checklist.items.create(item_params)
    render json: item
  end

  def update
    item = @checklist.items.find(params[:id])
    item.update(item_params)
    render json: item
  end

  private

  def set_checklist
    @checklist = current_user.owned_checklists.find(params[:checklist_id])
  end

  def item_params
    params.require(:item).permit(:content, :checked, :ordering)
  end
end
