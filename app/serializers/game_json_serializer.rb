# frozen_string_literal: true

class GameJsonSerializer < ActiveModel::Serializer
  attributes :id, :completed, :current_frame, :current_score, :frames

  has_many :frames, serializer: ::FrameJsonSerializer

  def current_frame
    object.current_frame.frame_number || Frame::MAX_FRAME_NUMBER
  end

  def current_score
    object.frames.sum(&:score)
  end
end
