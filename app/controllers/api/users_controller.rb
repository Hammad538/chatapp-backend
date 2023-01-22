# frozen_string_literal: true

module Api
  class UsersController < BaseController
    def create
      @user = User.new(user_params)
      if @user.save
        render json: @user, status: 200, each_serializer: Api::UserSerializer
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def verify_otp
      @user = User.find_by(id: params[:id])
      if params[:otp].present? && @user.authenticate_otp(params[:otp], drift: 7.days.to_i)
        render json: @user, status: 200
      else
        # NumberVerificationService.new(@user).send
        render json: { errors: @user.errors.full_messages }, status: 422
      end
    end

    private

    def user_params
      params.require(:users).permit(:name, :phone_number, :image, :password, :password_confirmation)
    end
  end
end
