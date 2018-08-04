# frozen_string_literal: true

Rails.application.routes.draw do
  resources :payments, only: :create
  resources :pots, only: :index

  root "pots#index"
end
