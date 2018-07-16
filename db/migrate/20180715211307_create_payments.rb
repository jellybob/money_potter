# frozen_string_literal: true

class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.monetize :amount
      t.belongs_to :pot, foreign_key: true
      t.string :tags, array: true, default: []
      t.timestamps
    end
  end
end
