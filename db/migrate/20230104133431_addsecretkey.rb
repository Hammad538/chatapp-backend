# frozen_string_literal: true

class Addsecretkey < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :otp_secret_key, :string
  end
end
