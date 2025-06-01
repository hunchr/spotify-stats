# frozen_string_literal: true

Rails.application.routes.draw do
  resources :imports, only: %i[new create]
end
