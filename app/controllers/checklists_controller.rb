class ChecklistsController < ApplicationController
  def index
    render json: Checklist.all
  end
end
