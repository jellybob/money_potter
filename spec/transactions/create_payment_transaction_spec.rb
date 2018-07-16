# frozen_string_literal: true

require "rails_helper"

RSpec.describe CreatePaymentTransaction, type: :model do
  it "instantiates and calls itself" do
    expect_any_instance_of(CreatePaymentTransaction).to \
      receive(:call).with("attributes")

    CreatePaymentTransaction.call("attributes")
  end

  let(:pot) { Pot.new(name: "Test") }
  let(:payment) { Payment.new(pot: pot, amount: 12.5) }
  let(:run) { CreatePaymentTransaction.call("attributes") }

  describe "when the payment is valid" do
    before do
      expect(Payment).to receive(:create!).with("attributes").and_return(payment)
    end

    it "creates and returns the payment" do
      expect(run).to eq(payment)
    end

    it "attempts to update the payment total" do
      expect(pot).to receive(:update_payments_total)

      run
    end
  end

  describe "when the payment is not valid" do
    before do
      expect(Payment).to receive(:create!).with("attributes").and_raise(ActiveRecord::RecordInvalid)
    end

    it "re-raises the exception" do
      expect { run }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "doesn't attempt an update of the payment total" do
      begin
        expect(pot).not_to receive(:update_payments_total)

        run
      rescue ActiveRecord::RecordInvalid
        # Its ok!
      end
    end
  end

  describe "when updating the payment total fails" do
    let(:pot) { Pot.create!(name: "Test", budget: 500) }
    let(:run) do
      CreatePaymentTransaction.call(pot: pot, amount: 12.5)
    end

    it "does not write anything to the database" do
      begin
        allow(pot).to receive(:update_payments_total).and_raise(RuntimeError)

        expect { run }.not_to change(Payment, :count)
      rescue RuntimeError
        # This was expected
      end
    end
  end
end
