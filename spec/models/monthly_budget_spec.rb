# frozen_string_literal: true

require "rails_helper"

RSpec.describe MonthlyBudget, type: :model do
  let(:pot) { Pot.create!(name: "Example", budget: 4000) }

  it "has a monetized amount field" do
    expect(MonthlyBudget.new).to respond_to(:amount)
    expect(MonthlyBudget.new.amount).to eq(Money.new(0))
  end

  it "has a monetized payments_total field" do
    expect(MonthlyBudget.new).to respond_to(:payments_total)
    expect(MonthlyBudget.new.payments_total).to eq(Money.new(0))
  end

  it { is_expected.to belong_to(:pot) }
  it { is_expected.to have_many(:payments) }
  it { is_expected.to validate_presence_of(:pot) }
  it { is_expected.to validate_presence_of(:month) }
  specify {
    expect(MonthlyBudget.new(pot: pot, month: Date.today.beginning_of_month)).to \
      validate_uniqueness_of(:month).scoped_to(:pot_id)
  }

  it {
    is_expected.to \
      validate_numericality_of(:amount)
        .only_integer
        .is_greater_than_or_equal_to(0)
  }

  describe "tracking how much has been spent" do
    let(:groceries) { CreatePotTransaction.call(name: "Groceries", budget: 100).current_budget }
    let(:eating_out) { CreatePotTransaction.call(name: "Eating Out", budget: 250).current_budget }

    it "sums all payments for the month to find the payments total" do
      Payment.create!(monthly_budget_id: groceries.id, amount: 10)
      Payment.create!(monthly_budget_id: eating_out.id, amount: 10)
      Payment.create!(monthly_budget_id: groceries.id, amount: 10)

      groceries.update_payments_total

      expect(groceries.payments_total.format).to eq("£20.00")
    end
  end

  describe "calculations" do
    let(:budget) { CreatePotTransaction.call(name: "Test Pot", budget: 500).current_budget }

    context "proportions" do
      before(:each) do
        values = [250, 0, 499.5, 500, 502.6, 1000].map { |v| Money.new(v * 100) }
        allow(budget).to \
          receive(:payments_total)
          .and_return(*values)
      end

      it "can report what proportion of the budget has been consumed" do
        # Use approximate matchers because I can't be bothered with super detailed
        # rounding errors.
        expect(budget.percent_consumed).to be_within(0.5).of(50)
        expect(budget.percent_consumed).to be_within(0.5).of(0)
        expect(budget.percent_consumed).to be_within(0.5).of(99.9)
        expect(budget.percent_consumed).to be_within(0.5).of(100)
        expect(budget.percent_consumed).to be_within(0.5).of(101)
        expect(budget.percent_consumed).to be_within(0.5).of(200)
      end

      it "can report how much of the budget remains" do
        expect(budget.amount_remaining).to eq(Money.new(250 * 100))
        expect(budget.amount_remaining).to eq(Money.new(500 * 100))
        expect(budget.amount_remaining).to eq(Money.new(0.5 * 100))
        expect(budget.amount_remaining).to eq(Money.new(0 * 100))
        expect(budget.amount_remaining).to eq(Money.new(-2.6 * 100))
        expect(budget.amount_remaining).to eq(Money.new(-500 * 100))
      end

      it "can report the state of the budget" do
        expect(budget.state).to eq(:under)
        expect(budget.state).to eq(:under)
        expect(budget.state).to eq(:warning)
        expect(budget.state).to eq(:warning)
        expect(budget.state).to eq(:over)
        expect(budget.state).to eq(:over)
      end
    end
  end
end
