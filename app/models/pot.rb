# frozen_string_literal: true

class Pot < ApplicationRecord
  validates :name, presence: true
  monetize :budget_pence, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  monetize :payments_total_pence

  has_many :payments
  has_many :monthly_budgets, -> { order(:month) }
  has_one :current_budget, -> { where(month: Date.today.beginning_of_month) }, class_name: "MonthlyBudget"

  def percent_consumed
    (payments_total.to_f / budget.to_f) * 100
  end

  def budget_remaining
    budget - payments_total
  end

  def state
    consumed = percent_consumed
    if consumed < 75
      :under
    elsif consumed <= 100
      :warning
    else
      :over
    end
  end
end
