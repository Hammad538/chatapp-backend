# frozen_string_literal: true

module SessionConcern
  extend ActiveSupport::Concern

  def session_expiry
    return if get_session_time_left

    session[:token] = nil
    render json: 'Your session has been timeout please Login again'
  end

  def get_session_time_left
    @session_time_left = Time.now.to_time.to_i - session[:expires_at].to_time.to_i
    @session_time_left < 100
  end

  def check_session_token
    render json: { message: 'Invalid Session Token' } unless params[:token] && params[:token] == session[:token]
  end
end
