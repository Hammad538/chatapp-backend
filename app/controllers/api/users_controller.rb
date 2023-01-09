# frozen_string_literal: true

module Api
  class UsersController < BaseController
    def create
      @user = User.new(user_params)
      result = NumberVerificationService.new(@user).send
      if @user.save
        render json: @user, status: 200
      else
        render json: @user.errors.full_messages, status: :unprocessable_entity
      end
    end

    def verify_otp
      @user = User.find_by(params[:id])
      if params[:otp].present? && @user.authenticate_otp(params[:otp], drift: 7.days.to_i)
        render json: 'Success', status: 200
      else
        NumberVerificationService.new(user: @user).send
        render json: 'Please try again with new otp'
      end
    end

    private

    def user_params
      params.require(:user).permit(:name, :phone_number, :image, :password, :password_confirmation)
    end
  end
end
