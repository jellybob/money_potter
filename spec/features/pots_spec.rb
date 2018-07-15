# frozen_string_literal: true

require "rails_helper"

RSpec.feature "pot management" do
  let!(:groceries) do
    Pot
      .create!(name: "Groceries", budget: 60, payments_total: 20)
  end

  let!(:eating_out) do
    Pot
      .create!(name: "Eating Out", budget: 40, payments_total: 40.01)
  end

  let!(:arthur) do
    Pot
      .create!(name: "Arthur", budget: 60, payments_total: 59.99)
  end

  before do
    visit "/pots"
  end

  scenario "lists existing pots with a progress bar" do
    within("#pot_#{groceries.id}") do
      expect(page).to have_selector("h2", text: "Groceries")
      expect(page).to have_selector(".progress-bar[aria-valuenow=33]")
    end
  end

  scenario "shows under budget pots in green" do
    expect(page).to have_selector("#pot_#{groceries.id}.pot-summary--under-budget")
    within("#pot_#{groceries.id}") do
      expect(page).to have_text("£40.00 remaining")
    end
  end

  scenario "shows approaching budget pots in yellow" do
    expect(page).to have_selector("#pot_#{arthur.id}.pot-summary--warning-budget")
    within("#pot_#{arthur.id}") do
      expect(page).to have_text("£0.01 remaining")
    end
  end

  scenario "shows over budget pots in red" do
    expect(page).to have_selector("#pot_#{eating_out.id}.pot-summary--over-budget")
    within("#pot_#{eating_out.id}") do
      expect(page).to have_text("£0.01 over budget")
    end
  end
end
