# frozen_string_literal: true

class CreatePaymentTransaction
  def self.call(attributes)
    new.call(attributes)
  end

  def call(attributes)
    ActiveRecord::Base.transaction do
      Payment.create!(attributes).tap do |payment|
        payment.pot.update_payments_total
      end
    end
  end
end
