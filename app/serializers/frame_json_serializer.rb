# frozen_string_literal: true

class FrameJsonSerializer < ActiveModel::Serializer
  attributes :carry_over_rolls, :completed, :frame_number, :score, :rolls

  has_many :rolls, serializer: ::RollJsonSerializer

  def score
    object.carry_over_rolls.positive? ? '' : object.score
  end
end
