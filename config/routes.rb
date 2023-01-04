# frozen_string_literal: true

Rails.application.routes.draw do
  resources :messages
  namespace :api, defaults: { format: 'json' } do
    resources :users do
      member do
        get :verify_otp
      end
    end
  end
end
