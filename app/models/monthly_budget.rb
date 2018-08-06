# frozen_string_literal: true

class MonthlyBudget < ApplicationRecord
  belongs_to :pot
  has_many :payments, -> { order(:created_at, :desc) }

  validates :pot, presence: true
  validates :month, presence: true, uniqueness: { scope: :pot_id }
  monetize :amount_pence, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  monetize :payments_total_pence

  def update_payments_total
    new_total = Money.new(payments.sum(:amount_pence))
    update_attribute(:payments_total, new_total)
  end
end
