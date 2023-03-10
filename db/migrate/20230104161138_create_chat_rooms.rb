# frozen_string_literal: true

class CreateChatRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_rooms do |t|
      t.string :name, null: false, default: ''
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
