# frozen_string_literal: true

if Rails.env.development?
  Rack::MiniProfiler.config.position = "bottom-right"
end
