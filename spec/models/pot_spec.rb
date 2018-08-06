# frozen_string_literal: true

require "rails_helper"

RSpec.describe Pot, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it {
    is_expected.to \
      validate_numericality_of(:budget)
        .only_integer
        .is_greater_than_or_equal_to(0)
  }

  describe "monthly budgets" do
    it { is_expected.to have_many(:monthly_budgets).order(:month) }

    it "can retrieve the budget for the current month" do
      pot = Pot.create!(name: "Test", budget: 40)
      budget = pot.monthly_budgets.create!(month: Date.today.beginning_of_month, amount: 40)

      expect(pot.current_budget).to eq(budget)
    end

    it "can create the budget for the current month" do
      pot = Pot.create!(name: "Test", budget: 40)
      budget = pot.create_current_budget(amount: 40)

      expect(budget.month).to eq(Date.today.beginning_of_month)
      expect(budget.pot_id).to eq(pot.id)
      expect(budget.amount).to eq(Money.new(4000))
    end
  end

  describe "budget calculations" do
    let(:pot) { Pot.create!(name: "Test Pot", budget: 500) }

    it "can report how much of the budget is used (currently stubbed to a random value)" do
      expect(pot.payments_total).not_to be_nil
      expect(pot.payments_total).to be >= 0
    end

    context "proportions" do
      before(:each) do
        values = [250, 0, 499.5, 500, 502.6, 1000].map { |v| Money.new(v * 100) }
        allow(pot).to \
          receive(:payments_total)
          .and_return(*values)
      end

      it "can report what proportion of the budget has been consumed" do
        # Use approximate matchers because I can't be bothered with super detailed
        # rounding errors.
        expect(pot.percent_consumed).to be_within(0.5).of(50)
        expect(pot.percent_consumed).to be_within(0.5).of(0)
        expect(pot.percent_consumed).to be_within(0.5).of(99.9)
        expect(pot.percent_consumed).to be_within(0.5).of(100)
        expect(pot.percent_consumed).to be_within(0.5).of(101)
        expect(pot.percent_consumed).to be_within(0.5).of(200)
      end

      it "can report how much of the budget remains" do
        expect(pot.budget_remaining).to eq(Money.new(250 * 100))
        expect(pot.budget_remaining).to eq(Money.new(500 * 100))
        expect(pot.budget_remaining).to eq(Money.new(0.5 * 100))
        expect(pot.budget_remaining).to eq(Money.new(0 * 100))
        expect(pot.budget_remaining).to eq(Money.new(-2.6 * 100))
        expect(pot.budget_remaining).to eq(Money.new(-500 * 100))
      end

      it "can report the state of the budget" do
        expect(pot.state).to eq(:under)
        expect(pot.state).to eq(:under)
        expect(pot.state).to eq(:warning)
        expect(pot.state).to eq(:warning)
        expect(pot.state).to eq(:over)
        expect(pot.state).to eq(:over)
      end
    end
  end
end
