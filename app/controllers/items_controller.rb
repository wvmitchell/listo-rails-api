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

  def destroy
    item = @checklist.items.find(params[:id])
    item.destroy!
    render json: { message: "Item deleted", status: :ok }
  rescue ActiveRecord::RecordNotFound
    render json: { message: "Item not found", status: :not_found }
  rescue ActiveRecord::RecordNotDestroyed => e
    render json: {
             message: "Item could not be deleted: #{e.message}",
             status: :unprocessable_entity
           }
  rescue StandardError => e
    render json: { message: e.message, status: :unprocessable_entity }
  end

  private

  def set_checklist
    @checklist = current_user.owned_checklists.find(params[:checklist_id])
  end

  def item_params
    params.require(:item).permit(:content, :checked, :ordering)
  end
end
