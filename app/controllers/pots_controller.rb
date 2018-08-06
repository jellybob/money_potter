# frozen_string_literal: true

class PotsController < ApplicationController
  def index
    @monthly_budgets = MonthlyBudget.this_month.joins(:pot).includes(:pot).order("pots.name").all
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
