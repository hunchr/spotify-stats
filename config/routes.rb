# frozen_string_literal: true

Rails.application.routes.draw do
  root "home#show"
  get "stats", to: "home#stats"

  resources :imports, only: %i[new create]

  resources :artists, only: %i[index show] do
    get :streak, on: :collection
  end
  resources :songs, only: %i[index show] do
    get :per_day, on: :collection
  end

  resources :podcasts, only: %i[index show]
end
