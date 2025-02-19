# frozen_string_literal: true

class Roll < ApplicationRecord
  MIN_PINS_PER_ROLL = 0
  MAX_PINS_PER_ROLL = 10

  attribute :created_at, :datetime
  attribute :pins
  attribute :updated_at, :datetime

  belongs_to :frame

  validates :pins, numericality: {
    greater_than_or_equal_to: MIN_PINS_PER_ROLL,
    less_than_or_equal_to: MAX_PINS_PER_ROLL
  }
end
