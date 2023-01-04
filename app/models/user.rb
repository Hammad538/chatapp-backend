# frozen_string_literal: true

class User < ApplicationRecord
  has_one_time_password column_name: :otp_secret_key, length: 6
  validates :name, :phone_number, :image, presence: true
  validates :phone_number, numericality: true, length: { minimum: 11, maximum: 15 }
  validates :name, :phone_number, uniqueness: true

  after_initialize :generate_otp_secret_key, :ensure_session_token, if: :new_record?

  def generate_otp_secret_key
    self.otp_secret_key = User.otp_random_secret
  end

  def ensure_session_token
    generate_unique_session_token unless session_token
  end

  def new_session_token
    SecureRandom.urlsafe_base64
  end

  def generate_unique_session_token
    self.session_token = new_session_token
  end
end
