# frozen_string_literal: true

require "rails_helper"

RSpec.feature "pot management" do
  scenario "lists existing pots" do
    Pot.create!(name: "Groceries")
    Pot.create!(name: "Eating Out")
    visit "/pots"

    expect(page).to have_text("Pots")
    expect(page).to have_text("Groceries")
    expect(page).to have_text("Eating Out")
  end
end
