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
      key.failure('cannot be a spare on the first roll') if game.current_frame.rolls.empty?
    elsif value.upcase == PIN[:STRIKE]
      key.failure('cannot be a strike on the second roll') if game.current_frame.rolls.any?
    end

    key.failure("cannot exceed the frame score limit of #{Roll::MAX_PINS_PER_ROLL}") if invalid_frame_score?(value)
  end

  private

  def acceptable_pin?(value)
    Roll::ACCEPTABLE_PIN_VALUES.include?(value)
  end

  # @todo: this could be reworked
  def invalid_frame_score?(value)
    non_character = PIN.values.exclude?(value)
    exceeds_score_limit = value.to_i + game.current_frame.score > Roll::MAX_PINS_PER_ROLL

    non_character && exceeds_score_limit
  end
end
