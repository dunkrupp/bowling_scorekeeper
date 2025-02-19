# frozen_string_literal: true

class GameJsonSerializer < ActiveModel::Serializer
  attributes :id, :completed, :frames, :updated_at, :created_at

  has_many :frames, serializer: ::FrameJsonSerializer
end
