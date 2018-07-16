# frozen_string_literal: true

class Payment < ApplicationRecord
  belongs_to :pot
  monetize :amount_pence

  validates :pot_id, presence: true

  def tags=(value)
    return super(value) if value.is_a?(Array)

    super(value.to_s.split(",").map(&:strip))
  end
end
