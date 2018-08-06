# frozen_string_literal: true

class MovePaymentsAssociationToBudgets < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :monthly_budget_id, :bigint, references: :monthly_budgets
    remove_column :payments, :pot_id
  end
end
