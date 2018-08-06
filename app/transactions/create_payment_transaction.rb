# frozen_string_literal: true

class CreatePaymentTransaction
  def self.call(monthly_budget_id:, amount:, tags:)
    new.call(monthly_budget_id: monthly_budget_id, amount: amount, tags: tags)
  end

  def call(monthly_budget_id:, amount:, tags:)
    ActiveRecord::Base.transaction do
      Payment.create!(monthly_budget_id: monthly_budget_id, amount: amount, tags: tags).tap do |payment|
        payment.monthly_budget.update_payments_total
      end
    end
  end
end
