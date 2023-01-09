# frozen_string_literal: true

module Api
  class SessionsController < BaseController
    include SessionConcern
    before_action :check_session_token, only: [:destroy]
    def create
      if session[:token].present? && get_session_time_left
        render json: { message: 'Already Logged In' },
               status: 422 and return
      end

      user = User.find_by_phone_number(params[:phone_number])
      if user&.authenticate(params[:password])
        session[:token] = new_session_token
        render json: { user: user, token: session[:token], message: 'Success' }
      else
        render json: 'Invalid Credentials'
      end
    end

    def destroy
      session[:token] = nil
      render json: 'You have been logout'
    end

    private

    def new_session_token
      session[:expires_at] = Time.now
      SecureRandom.urlsafe_base64
    end
  end
end
