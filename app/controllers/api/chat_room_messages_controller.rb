# frozen_string_literal: true

module Api
  class ChatRoomMessagesController < BaseController
    include SessionConcern
    before_action :set_users, only: [:create]
    before_action :check_session_token
    before_action :session_expiry

    def index
      if params[:chat_room_id].present?
        @chat_room_messages = ChatRoomMessage.where(chat_room_id: params[:chat_room_id]).order('created_at ASC')
      end
      if @chat_room_messages.present?
        render json: @chat_room_messages
      else
        render json: 'You have no conversation with this user'
      end
    end

    def create
      @message, @chat_room = ChatRoomService.new(sender: @user1, receiver: @user2,
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
      params.require(:chat_room_message).permit(:body)
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
