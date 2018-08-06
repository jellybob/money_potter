# frozen_string_literal: true

require "rails_helper"

RSpec.describe CreatePaymentTransaction, type: :model do
  it "instantiates and calls itself" do
    expect_any_instance_of(CreatePaymentTransaction).to \
      receive(:call).with(attributes)

    CreatePaymentTransaction.call(attributes)
  end

  let(:pot) { Pot.create!(name: "Test", budget: 4000) }
  let(:budget) { pot.create_current_budget }
  let(:payment) { Payment.new(monthly_budget: budget, amount: 12.5) }
  let(:attributes) { { monthly_budget_id: budget.id, amount: 12.5, tags: "" } }
  let(:run) { CreatePaymentTransaction.call(attributes) }

  describe "when the payment is valid" do
    before do
      expect(Payment).to receive(:create!).with(attributes).and_return(payment)
    end

    it "creates and returns the payment" do
      expect(run).to eq(payment)
    end

    it "attempts to update the payment total" do
      expect(budget).to receive(:update_payments_total)

      run
    end
  end

  describe "when the payment is not valid" do
    before do
      expect(Payment).to receive(:create!).with(attributes).and_raise(ActiveRecord::RecordInvalid)
    end

    it "re-raises the exception" do
      expect { run }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "doesn't attempt an update of the payment total" do
      begin
        expect(budget).not_to receive(:update_payments_total)

        run
      rescue ActiveRecord::RecordInvalid
        # Its ok!
      end
    end
  end

  describe "when updating the payment total fails" do
    let(:pot) { Pot.create!(name: "Test", budget: 500) }
    let(:budget) { CreatePotTransaction.call(name: "Test", budget: 50).current_budget }
    let(:run) do
      CreatePaymentTransaction.call(monthly_budget_id: budget.id, amount: 12.5, tags: "")
    end

    it "does not write anything to the database" do
      begin
        allow_any_instance_of(MonthlyBudget).to receive(:update_payments_total).and_raise(RuntimeError)

        expect { run }.not_to change(Payment, :count)
      rescue RuntimeError
        # This was expected
      end
    end
  end
end
