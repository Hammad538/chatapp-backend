# frozen_string_literal: true

module Api
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :name, :phone_number, :image
    include Rails.application.routes.url_helpers
    def image
      rails_blob_path(object.image, only_path: true) if object.image.attached?
    end
  end
end
