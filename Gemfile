# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.5.1"

gem "bcrypt", "~> 3.1.7"
gem "bootsnap", ">= 1.2.0", require: false
gem "money-rails", "~> 1"
gem "pg", ">= 0.18", "< 2.0"
gem "puma", "~> 3.11"
gem "rails", "~> 5.2.0"
gem "redis", "~> 4.0"
gem "rein", "~> 3"
gem "sass-rails", "~> 5.0"
gem "turbolinks", "~> 5"
gem "uglifier", ">= 1.3.0"
gem "webpacker"

group :development, :test do
  gem "bullet"
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "capybara", ">= 2.4"
  gem "rails-controller-testing"
  gem "rspec-rails", "~> 3.7"
  gem "rubocop-rails_config"
  gem "shoulda-matchers"
end

group :development do
  gem "flamegraph"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "memory_profiler"
  gem "rack-mini-profiler"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "stackprof"
  gem "web-console", ">= 3.3.0"
end
