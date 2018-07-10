# frozen_string_literal: true

if Rails.env.development?
  Bullet.enable = true
  Bullet.add_footer = true
  Bullet.console = true
end
