# frozen_string_literal: true

namespace :cron do
  task rotate_budgets: :environment do
    start_date = Date.today.end_of_month + 1.day
    Pot.find_each do |pot|
      puts "Rotating budgets for #{pot.name}"
      pot
        .monthly_budgets
        .create_with(amount: pot.budget)
        .find_or_create_by(month: start_date)
    end
  end
end
