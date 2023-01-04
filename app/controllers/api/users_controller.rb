# frozen_string_literal: true

module Api
  class UsersController < BaseController
    before_action :set_user, only: %i[verify_otp]
    def create
      @user = User.new(user_params)
      result = NumberVerificationService.new(@user).send
      if [true].include?(result) && @user.save
        render json: @user, status: 200
      else
        render json: @user.errors.full_messages, status: :unprocessable_entity
      end
    end

    def verify_otp
      if params[:otp].present? && @user.authenticate_otp(params[:otp], drift: 7.days.to_i)
        render json: 'Success', status: 200
      else
        NumberVerificationService.new(user: @user).send
        render json: 'Please try again with new otp'
      end
    end

    private

    def set_user
      @user = User.find_by(id: params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :phone_number, :image)
    end
  end
end
