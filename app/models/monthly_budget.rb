# frozen_string_literal: true

class MonthlyBudget < ApplicationRecord
  belongs_to :pot
  has_many :payments, -> { order(:created_at, :desc) }

  delegate :name, to: :pot

  validates :pot, presence: true
  validates :month, presence: true, uniqueness: { scope: :pot_id }
  monetize :amount_pence, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  monetize :payments_total_pence

  scope :this_month, -> { where(month: Date.today.beginning_of_month) }

  def update_payments_total
    new_total = Money.new(payments.sum(:amount_pence))
    update_attribute(:payments_total, new_total)
  end

  def percent_consumed
    (payments_total.to_f / amount.to_f) * 100
  end

  def amount_remaining
    amount - payments_total
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
