# frozen_string_literal: true

class RollJsonSerializer < ActiveModel::Serializer
  MAX_SCORE = Roll::MAX_PINS_PER_ROLL
  MIN_SCORE = Roll::MIN_PINS_PER_ROLL
  PINS = Roll::PIN_CHARACTERS

  attributes :id, :pins

  def pins
    if object.strike?
      PINS[:STRIKE]
    elsif object.miss?
      PINS[:MISS]
    elsif object.spare?
      PINS[:SPARE]
    else
      object.pins.to_s
    end
  end
end
