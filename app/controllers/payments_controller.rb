# frozen_string_literal: true

class PaymentsController < ApplicationController
  def create
    CreatePaymentTransaction.call(payment_attributes)
    flash.success = "Payment tracked"
  rescue ActiveRecord::RecordInvalid
    flash.danger = "Some details were missing"
  ensure
    redirect_to pots_path
  end

  protected

    def payment_attributes
      params.require(:payment).permit(:pot_id, :amount, :tags).to_h.symbolize_keys
    end
end
