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
end
