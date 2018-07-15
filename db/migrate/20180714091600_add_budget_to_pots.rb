# frozen_string_literal: true

class AddBudgetToPots < ActiveRecord::Migration[5.2]
  def change
    add_monetize :pots, :budget
    add_numericality_constraint :pots, :budget_pence, greater_than_or_equal_to: 0, only_integer: true
    add_presence_constraint :pots, :name
  end
end
