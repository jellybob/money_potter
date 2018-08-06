# frozen_string_literal: true

require "rails_helper"

RSpec.feature "pot management" do
  let!(:groceries) do
    CreatePotTransaction
      .call(name: "Groceries", budget: 60)
      .tap { |p| p.current_budget.update_attribute(:payments_total, 20) }
      .current_budget
  end

  let!(:eating_out) do
    CreatePotTransaction
      .call(name: "Eating Out", budget: 40)
      .tap { |p| p.current_budget.update_attribute(:payments_total, 40.01) }
      .current_budget
  end

  let!(:arthur) do
    CreatePotTransaction
      .call(name: "Arthur", budget: 60)
      .tap { |p| p.current_budget.update_attribute(:payments_total, 59.99) }
      .current_budget
  end

  before do
    visit "/pots"
  end

  scenario "lists existing pots with a progress bar" do
    within("#monthly_budget_#{groceries.id}") do
      expect(page).to have_selector("h2", text: "Groceries")
      expect(page).to have_selector(".progress-bar[aria-valuenow=33]")
    end
  end

  scenario "shows under budget pots in green" do
    expect(page).to have_selector("#monthly_budget_#{groceries.id}.budget-summary--under-budget")
    within("#monthly_budget_#{groceries.id}") do
      expect(page).to have_text("£40.00 remaining")
    end
  end

  scenario "shows approaching budget pots in yellow" do
    expect(page).to have_selector("#monthly_budget_#{arthur.id}.budget-summary--warning-budget")
    within("#monthly_budget_#{arthur.id}") do
      expect(page).to have_text("£0.01 remaining")
    end
  end

  scenario "shows over budget pots in red" do
    expect(page).to have_selector("#monthly_budget_#{eating_out.id}.budget-summary--over-budget")
    within("#monthly_budget_#{eating_out.id}") do
      expect(page).to have_text("£0.01 over budget")
    end
  end

  scenario "creating a new pot" do
    expect(page).to have_selector("#new_pot")
    within("#new_pot") do
      fill_in "Name", with: "Games"
      fill_in "Monthly Budget", with: "43"
      click_on "Create Pot"
    end

    expect(page).to have_text("Created Games with a budget of £43")
    expect(page).to have_selector(".budget-summary h2", text: "Games")
  end
end
