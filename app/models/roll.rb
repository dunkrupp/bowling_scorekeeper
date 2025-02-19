# frozen_string_literal: true

class Roll < ApplicationRecord
  MAX_PINS_PER_ROLL = 10
  MIN_PINS_PER_ROLL = 0

  PIN_CHARACTERS = {
    :STRIKE => 'X',
    :SPARE => '/',
    :MISS => '-'
  }.freeze

  ACCEPTABLE_PIN_CHARACTERS = PIN_CHARACTERS.values.freeze
  ACCEPTABLE_PIN_DIGITS = (0..10).to_a.map(&:to_s).freeze
  ACCEPTABLE_PIN_VALUES = (ACCEPTABLE_PIN_DIGITS | ACCEPTABLE_PIN_CHARACTERS).freeze

  attribute :created_at, :datetime
  attribute :pins
  attribute :updated_at, :datetime

  belongs_to :frame

  validates :pins, numericality: {
    greater_than_or_equal_to: MIN_PINS_PER_ROLL,
    less_than_or_equal_to: MAX_PINS_PER_ROLL
  }

  def miss?
    pins == MIN_PINS_PER_ROLL
  end

  def spare?
    !strike? && frame.score == MAX_PINS_PER_ROLL # not big on accessing the frame
  end

  def strike?
    pins == MAX_PINS_PER_ROLL
  end
end
