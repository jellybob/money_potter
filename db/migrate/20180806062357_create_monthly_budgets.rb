# frozen_string_literal: true

class CreateMonthlyBudgets < ActiveRecord::Migration[5.2]
  def change
    create_table :monthly_budgets do |t|
      t.belongs_to :pot, foreign_key: true
      t.date :month, null: false
      t.monetize :amount
      t.monetize :payments_total
    end
  end
end
