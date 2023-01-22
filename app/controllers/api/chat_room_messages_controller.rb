# frozen_string_literal: true

module Api
  class ChatRoomMessagesController < BaseController
    include SessionConcern
    before_action :set_users, only: [:create]
    # before_action :check_session_token
    # before_action :session_expiry

    def index
      # byebug
      # if params[:chat_room_id].present?
      #   @chat_room_messages = ChatRoomMessage.where(chat_room_id: params[:chat_room_id]).order('created_at ASC')
      # end
      # if @chat_room_messages.present?
      #   render json: @chat_room_messages
      # else
      #   render json: 'You have no conversation with this user'
      # end
      if params[:sender_id].present? && params[:receiver_id].present?

        @chat_room_sender = ChatRoom.where(user_id: params[:sender_id]).includes(:chat_room_participants).where(chat_room_participants: { user_id: params[:receiver_id] }).first
        @chat_room_receiver = ChatRoom.where(user_id: params[:receiver_id]).includes(:chat_room_participants).where(chat_room_participants: { user_id: params[:sender_id] }).first
        @chat_room = @chat_room_sender || @chat_room_receiver
        if @chat_room_sender.present? || @chat_room_receiver.present?
          @chat_room_messages = @chat_room.chat_room_messages.order('created_at ASC')
        end

        render json: @chat_room_messages, status: 200
      else
        render json: { error: 'You have no conversation with this user' }, status: 422
      end
    end

    def create
      @message = ChatRoomMessage.new(message_params.merge!(chat_room_id: @chat_room.id,
                                                           chat_room_participant_id: @chat_room_participant.id))
      if @message.save
        ActionCable.server.broadcast "chat_room_#{@chat_room.id}",
                                     { message: Api::ChatRoomMessageSerializer.new(@message, root: false) }
      else
        render json: @message.errors.full_messages, status: 422
      end
    end

    private

    def message_params
      params.require(:chat_room_message).permit(:body)
    end

    def set_users
      @sender = User.find_by(id: params[:sender_id])
      @chat_room = ChatRoom.find_by(id: params[:chat_room_id])
      @chat_room_participant = begin
        ChatRoomParticipant.where(chat_room_id: @chat_room.id,
                                  user_id: @sender.id).first
      rescue StandardError
        nil
      end
      if !@sender.present?
        render json: 'Sender Is not present', status: 422
      elsif !@chat_room.present?
        render json: 'chat_room Is not present', status: 422
      elsif !@chat_room_participant.present?
        render json: 'chat_room_participant Is not present', status: 422
      end
    end
  end
end
