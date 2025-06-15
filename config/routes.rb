# frozen_string_literal: true

Rails.application.routes.draw do
  root "home#show"

  resources :artists, only: %i[index show] do
    get :streak, on: :collection
  end
  resources :imports, only: %i[new create]
  resources :songs, only: %i[index show] do
    get :per_day, on: :collection
  end
end
