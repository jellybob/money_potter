# frozen_string_literal: true

class CreatePotTransaction
  def self.call(attributes)
    new.call(attributes)
  end

  def call(attributes)
    ActiveRecord::Base.transaction do
      Pot.create!(attributes).tap do |pot|
        pot.create_current_budget(amount: pot.budget)
      end
    end
  end
end
