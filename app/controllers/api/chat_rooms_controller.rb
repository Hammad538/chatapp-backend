# frozen_string_literal: true

module Api
  class ChatRoomsController < BaseController
    before_action :set_users, only: [:create]
    def index
      chat_room_ids = current_user&.chat_rooms&.pluck(:id)
      if chat_room_ids.present?
        @user = User.joins(:chat_room_participants).where(chat_room_participants: { chat_room_id: chat_room_ids }).where.not(chat_room_participants: { user_id: current_user.id })
        render json: @user, status: 200, each_serializer: Api::UserSerializer if @user.present?
      else
        @user = User.all
        render json: @user, status: 200, each_serializer: Api::UserSerializer
      end
    end

    def create
      chat_room_service = ChatRoomService.new(sender: @sender, receiver: @reciever)
      @chat_room = chat_room_service.find_chat_room
      @chat_room = chat_room_service.call unless @chat_room.present?
      render json: @chat_room, status: 200
    end

    private

    def set_users
      @sender = User.find_by(id: params[:sender_id])
      @reciever = User.find_by(id: params[:receiver_id])
      if !@sender.present?
        render json: 'sender not found'
      elsif !@reciever.present?
        render json: 'reciever not found'
      end
    end
  end
end
