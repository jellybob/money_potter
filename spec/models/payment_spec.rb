# frozen_string_literal: true

require "rails_helper"

RSpec.describe Payment, type: :model do
  it { is_expected.to validate_presence_of(:monthly_budget_id) }
  it { is_expected.to validate_numericality_of(:amount) }

  describe "setting tags" do
    let(:payment) { Payment.new(amount: 10.00) }

    it "passes an array straight through" do
      payment.tags = %w(one two three)
      expect(payment.tags).to eq(%w(one two three))
    end

    it "splits a string on commas" do
      payment.tags = "one, two, three"
      expect(payment.tags).to eq(%w(one two three))
    end
  end
end
