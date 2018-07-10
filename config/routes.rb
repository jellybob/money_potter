# frozen_string_literal: true

Rails.application.routes.draw do
  get "/hello", controller: "home", action: "hello"
  root "home#index"
end
