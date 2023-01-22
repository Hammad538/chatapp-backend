# frozen_string_literal: true

class ChatRoomService < ApplicationService
  attr_reader :sender, :receiver

  def initialize(**args)
    @params = args
    @sender = @params[:sender]
    @receiver = @params[:receiver]
  end

  def call
    chat_room = create_chat_room
    chat_room_particpants = create_chat_room_particpants(chat_room)
    [] << chat_room
  end

  def create_chat_room
    phone_numbers = [sender.phone_number.last(3), receiver.phone_number.last(3)].sort!
    ChatRoom.create(name: phone_numbers.join('-'), user_id: sender.id)
  end

  def create_chat_room_particpants(chat_room)
    sender_particpant = ChatRoomParticipant.create(user_id: sender.id, chat_room_id: chat_room.id)
    reciver_particpant = ChatRoomParticipant.create(user_id: receiver.id, chat_room_id: chat_room.id)
  end

  def find_chat_room
    chat_room = ChatRoom.joins(:chat_room_participants).where(chat_room_participants: { user_id: [sender.id,
                                                                                                  receiver.id] }).group(:id).having('count(DISTINCT chat_room_participants.user_id) = 2')
  end
end
