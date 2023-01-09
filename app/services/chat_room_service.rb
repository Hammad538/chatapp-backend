# frozen_string_literal: true

class ChatRoomService < ApplicationService
  attr_reader :sender, :receiver, :message_params

  def initialize(**args)
    @params = args
    @sender = @params[:sender]
    @receiver = @params[:receiver]
    @message_params = @params[:message_params]
  end

  def search_chat_room
    phone_numbers = [sender.phone_number.last(3), receiver.phone_number.last(3)].sort!
    chat_room = ChatRoom.find_by(name: phone_numbers.join('-'))
    if chat_room.present?
      chat_room_particpant = ChatRoomParticipant.find_by(chat_room_id: chat_room.id,
                                                         user_id: sender.id || receiver.id)
    end
    chat_room, chat_room_particpant1 = create_chat_room(phone_numbers) unless chat_room_particpant.present?
    message = ChatRoomMessage.new(message_params)
    message.chat_room_id = chat_room.id
    message.chat_room_participant_id = chat_room_particpant1&.id || chat_room_particpant&.id
    [message, chat_room]
  end

  def create_chat_room(phone_numbers)
    chat_room = ChatRoom.create(name: phone_numbers.join('-'), user_id: sender.id)
    chat_room_particpant1 = ChatRoomParticipant.create(user_id: sender.id, chat_room_id: chat_room.id)
    chat_room_particpant2 = ChatRoomParticipant.create(user_id: receiver.id, chat_room_id: chat_room.id)
    [chat_room, chat_room_particpant1]
  end
end
