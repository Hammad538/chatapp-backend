# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

  def current_user
    @user = User.find_by(id: params[:user_id])
  end
end
