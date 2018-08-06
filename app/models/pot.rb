# frozen_string_literal: true

class Pot < ApplicationRecord
  validates :name, presence: true
  monetize :budget_pence, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  monetize :payments_total_pence

  has_many :payments
  has_many :monthly_budgets, -> { order(:month) }
  has_one :current_budget, -> { where(month: Date.today.beginning_of_month) }, class_name: "MonthlyBudget"
end
