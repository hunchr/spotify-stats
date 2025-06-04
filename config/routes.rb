# frozen_string_literal: true

Rails.application.routes.draw do
  root "home#show"

  resources :imports, only: %i[new create]
  resources :songs, only: %i[index show] do
    get :on_repeat, on: :collection
  end
end
