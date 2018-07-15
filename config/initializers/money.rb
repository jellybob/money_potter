# encoding : utf-8
# frozen_string_literal: true

MoneyRails.configure do |config|

  config.default_currency = :gbp

  # Default ActiveRecord migration configuration values for columns:
  #
  config.amount_column = {
    postfix: "_pence",
    type: :integer,
    present: true,
    null: false,
    default: 0
  }

  config.currency_column = {
    postfix: "_currency",
    type: :string,
    present: true,
    null: false,
    default: "GBP"
  }
end
