# frozen_string_literal: true

class Pot < ApplicationRecord
  validates :name, presence: true
  validates :budget, numericality: { greater_than_or_equal_to: 0, only_integer: true }
end
