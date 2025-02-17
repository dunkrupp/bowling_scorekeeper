# frozen_string_literal: true

Rails.application.routes.draw do
  get 'up' => "rails/health#show", as: :rails_health_check

  root to: 'rails/health#show'

  namespace :api do
    namespace :v1 do
      resources :games, only: [:create] do
        post :roll, on: :member
      end
    end
  end
end
