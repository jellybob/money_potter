# frozen_string_literal: true

class TrackPaymentsTotalInDatabase < ActiveRecord::Migration[5.2]
  def change
    add_monetize :pots, :payments_total, default: 0
  end
end
