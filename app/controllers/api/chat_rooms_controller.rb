# frozen_string_literal: true

module Api
  class ChatRoomsController < BaseController
    def index
      chat_room_ids = current_user&.chat_rooms&.pluck(:id)

      @user = User.joins(:chat_room_participants).where(chat_room_participants: { chat_room_id: chat_room_ids }).where.not(chat_room_participants: { user_id: current_user.id })
      if @user.present?
        render json: { user: @user, message: 'Success' }
      else
        render json: { message: 'No message in chat room' }
      end
    end
  end
end
