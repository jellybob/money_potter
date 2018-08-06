# frozen_string_literal: true

class CreatePaymentTransaction
  def self.call(pot_id:, amount:, tags:)
    new.call(pot_id: pot_id, amount: amount, tags: tags)
  end

  def call(pot_id:, amount:, tags:)
    ActiveRecord::Base.transaction do
      Payment.create!(pot_id: pot_id, amount: amount, tags: tags).tap do |payment|
        payment.pot.update_payments_total
      end
    end
  end
end
