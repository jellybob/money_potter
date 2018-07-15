# frozen_string_literal: true

class Pot < ApplicationRecord
  validates :name, presence: true
  monetize :budget_pence, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  def payments_total
    return @payments_total if @payments_total.present?

    possible_over_budget = (budget.to_i * 0.2)
    pounds = rand(budget.to_i + possible_over_budget) * 100
    pence = rand(100)
    @payments_total ||= Money.new(pounds + pence)
  end

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
