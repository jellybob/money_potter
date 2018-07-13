# frozen_string_literal: true

Rails.application.routes.draw do
  resources :pots, only: :index
end
