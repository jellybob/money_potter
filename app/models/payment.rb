# frozen_string_literal: true

class Payment < ApplicationRecord
  belongs_to :monthly_budget, touch: true
  monetize :amount_pence

  validates :monthly_budget_id, presence: true

  def tags=(value)
    return super(value) if value.is_a?(Array)

    super(value.to_s.split(",").map(&:strip))
  end
end
