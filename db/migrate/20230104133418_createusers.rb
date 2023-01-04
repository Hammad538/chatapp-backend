# frozen_string_literal: true

class Createusers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :phone_number, null: false, limit: 15
      t.string :image
      t.string :session_token, null: false
      t.timestamps
    end
    add_index :users, :phone_number, unique: true
    add_index :users, :session_token, unique: true
  end
end
