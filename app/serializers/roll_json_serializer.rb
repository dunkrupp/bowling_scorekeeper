# frozen_string_literal: true

class RollJsonSerializer < ActiveModel::Serializer
  MAX_SCORE = Roll::MAX_PINS_PER_ROLL
  MIN_SCORE = Roll::MIN_PINS_PER_ROLL
  PINS = Roll::PIN_CHARACTERS

  attributes :id, :pins

  def pins
    case
    when object.strike?
      PINS[:STRIKE]
    when object.miss?
      PINS[:MISS]
    when object.spare?
      PINS[:SPARE]
    else
      object.pins.to_s
    end
  end
end
