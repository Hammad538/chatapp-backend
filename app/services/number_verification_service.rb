# frozen_string_literal: true

require 'twilio-ruby'
class NumberVerificationService < ApplicationService
  include ActiveModel::Validations
  attr_reader :user, :client

  def initialize(user)
    @user = user
    @client = Twilio::REST::Client.new
  end

  def send
    client.messages.create(
      from: (ENV['TWILIO_PHONE_NUMBER']).to_s,
      to: @user.phone_number.to_s,
      body: "Please Enter This code: #{@user.otp_code}"
    )
    true
  rescue Twilio::REST::RestError => e
    @user.errors.add(:base, 'please Enter a valid phone number')
  end
end
