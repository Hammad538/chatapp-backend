# frozen_string_literal: true

Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  namespace :api, defaults: { format: 'json' } do
    post '/login', to: 'sessions#create'
    delete '/destroy', to: 'sessions#destroy'
    resources :users do
      member do
        get :verify_otp
      end
    end
    resources :chat_room_messages
    resources :chat_rooms, only: %i[index create]
  end
end
