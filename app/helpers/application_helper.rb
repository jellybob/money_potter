# frozen_string_literal: true

module ApplicationHelper
  def progress(percentage)
    [percentage.round, 100].min
  end
end
