# frozen_string_literal: true

class MonthlyBudget < ApplicationRecord
  belongs_to :pot
  validates :pot, presence: true
  validates :month, presence: true, uniqueness: { scope: :pot_id }
  monetize :amount_pence, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  monetize :payments_total_pence
end
