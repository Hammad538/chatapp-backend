# frozen_string_literal: true

module Api
  class ChatRoomMessagesController < BaseController
    before_action :set_users, only: [:create]
    def create
      @message, @chat_room = ChatRoomService.new(user1: @user1, user2: @user2,
                                                 message_params: message_params).search_chat_room
      if @chat_room.present? && @message.save
        ChatRoomChannel.broadcast_to(@chat_room.id, @message.body)
        render json: @message
      else
        render json: @message.errors.full_messages, status: 422
      end
    end

    private

    def message_params
      params.require(:messages).permit(:body)
    end

    def set_users
      if params[:phone_number].present? && params[:user_id].present?
        @user1 = User.find_by(id: params[:user_id])
        @user2 = User.find_by(phone_number: params[:phone_number])
      else
        render json: 'Please enter a valid phone number'
      end
    end
  end
end
