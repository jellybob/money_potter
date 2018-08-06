# frozen_string_literal: true

require "rails_helper"

RSpec.describe CreatePotTransaction, type: :model do
  it "instantiates and calls itself" do
    expect_any_instance_of(CreatePotTransaction).to \
      receive(:call).with("attributes")

    CreatePotTransaction.call("attributes")
  end

  def run(attributes = {})
    default_attributes = {
      name: "Test Pot",
      budget: 40,
    }

    CreatePotTransaction.call(default_attributes.merge(attributes))
  end

  describe "when the pot is valid" do
    it "creates and returns the pot" do
      pot = run
      expect(pot).to be_a(Pot)
      expect(pot.name).to eq("Test Pot")
      expect(pot.budget.to_i).to eq(40)
    end

    it "creates a monthly budget for the current month matching the pot's budget" do
      budget = run.current_budget

      expect(budget).not_to be_nil
      expect(budget.amount.to_i).to eq(40)
      expect(budget.month).to eq(Date.today.beginning_of_month)
    end
  end

  describe "when the pot is not valid" do
    it "re-raises the exception" do
      expect { run(name: nil) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "does not create a monthly budget" do
      expect {
        begin
          run(name: nil)
        rescue => _e
        end
      }.not_to change(MonthlyBudget, :count)
    end
  end
end
