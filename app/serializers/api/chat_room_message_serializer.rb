# frozen_string_literal: true

module Api
  class ChatRoomMessageSerializer < ActiveModel::Serializer
    attributes :id, :chat_room_participant_id, :body, :chat_room_id, :sender_id

    def sender_id
      object.chat_room_participant.user_id
    end
  end
end
