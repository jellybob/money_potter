# frozen_string_literal: true

class PaymentsController < ApplicationController
  def create
    CreatePaymentTransaction.call(payment_attributes)
    flash.success = "Payment tracked"
    redirect_back fallback_location: pots_path
  end

  protected

    def payment_attributes
      params.require(:payment).permit(:pot_id, :amount, :tags)
    end
end
