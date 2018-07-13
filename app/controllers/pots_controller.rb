# frozen_string_literal: true

class PotsController < ApplicationController
  def index
    @pots = Pot.order(:name).all
  end
end
