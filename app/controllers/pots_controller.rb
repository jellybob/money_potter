# frozen_string_literal: true

class PotsController < ApplicationController
  def index
    @pots = Pot.order(:name).all
  end

  def create
    @pot = CreatePotTransaction.call(pot_params)
    flash[:success] = "Created #{@pot.name} with a budget of #{@pot.budget.format}"
    redirect_to root_path
  end

  protected

    def pot_params
      params.require(:pot).permit(:name, :budget)
    end
end
