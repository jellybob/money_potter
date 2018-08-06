# frozen_string_literal: true

require "rails_helper"

RSpec.feature "payment tracking" do
  let!(:groceries) { CreatePotTransaction.call(name: "Groceries", budget: 320).current_budget }
  let!(:eating_out) { CreatePotTransaction.call(name: "Eating Out", budget: 60).current_budget }

  before { visit("/pots") }

  scenario "tracking a valid payment" do
    select "Groceries", from: "Pot"
    fill_in "Amount", with: 28.50
    fill_in "Tags", with: "Big shops"
    click_button "Track Payment"

    within "#monthly_budget_#{groceries.id}" do
      expect(page).to have_text("£291.50 remaining")
    end
  end

  scenario "tracking an invalid payment" do
    select "Groceries", from: "Pot"
    click_button "Track Payment"

    expect(page).to have_text("Some details were missing")
  end
end
