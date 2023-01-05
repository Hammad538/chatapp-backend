# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    resources :users do
      member do
        get :verify_otp
      end
    end
    resources :chat_room_messages
  end
end
