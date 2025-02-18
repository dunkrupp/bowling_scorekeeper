# frozen_string_literal: true

class Roll < ApplicationRecord
  MIN_PINS_PER_ROLL = 0
  MAX_PINS_PER_ROLL = 10

  belongs_to :frame

  attribute :pins

  validates :pins, numericality: {
    greater_than_or_equal_to: MIN_PINS_PER_ROLL,
    less_than_or_equal_to: MAX_PINS_PER_ROLL
  }
end
