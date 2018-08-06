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
end
