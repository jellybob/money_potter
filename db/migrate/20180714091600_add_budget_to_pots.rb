# frozen_string_literal: true

class AddBudgetToPots < ActiveRecord::Migration[5.2]
  def change
    add_column :pots, :budget, :integer, allow_null: false, default: 0
    add_numericality_constraint :pots, :budget, greater_than_or_equal_to: 0, only_integer: true
    add_presence_constraint :pots, :name
  end
end
