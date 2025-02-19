# frozen_string_literal: true

class RollContract < Dry::Validation::Contract
  PIN = Roll::PIN_CHARACTERS

  option :game

  params do
    required(:pins).filled(:string)
  end

  rule(:pins) do
    key.failure('must be a valid symbol (X, /, -) or a number between 0 and 10') unless acceptable_pin?(value)

    if value == PIN[:SPARE]
      key.failure('cannot be a spare on the first roll') if rolls.empty?
    elsif value.upcase == PIN[:STRIKE]
      key.failure('cannot be a strike on the second roll') if invalid_strike_entry?
    end

    key.failure("cannot exceed the frame score limit of #{Frame::MAX_SCORE_PER_FRAME}") if invalid_frame_score?(value)
  end

  private

  def acceptable_pin?(value)
    Roll::ACCEPTABLE_PIN_VALUES.include?(value)
  end

  def current_frame
    @current_frame ||= game.current_frame
  end

  def invalid_frame_score?(value)
    return false if PIN.value?(value)

    return true if value.to_i + current_frame.roll_sum > Roll::MAX_PINS_PER_ROLL && !current_frame.final_frame?

    false
  end

  def invalid_strike_entry?
    rolls.any? && !current_frame.final_frame?
  end

  def rolls
    @rolls ||= current_frame.rolls
  end
end
