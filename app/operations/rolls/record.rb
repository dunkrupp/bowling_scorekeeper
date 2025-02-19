# frozen_string_literal: true

module Rolls
  class Record < BaseOperation
    MIN_SCORE = Roll::MIN_PINS_PER_ROLL
    MAX_SCORE = Roll::MAX_PINS_PER_ROLL
    PIN = Roll::PIN_CHARACTERS

    attr_reader :game, :pins

    def call(game:, pins:)
      @game = game
      @pins = pins

      # @todo: could probably be an `ActiveRecord::Base.transaction`
      yield create_roll
      yield update_current_frame
      yield update_frames_with_carry_over_score

      Success(game.reload) # reload before we return
    rescue Dry::Monads::Do::Halt => e
      capture_and_fail(e.message, e)
    rescue StandardError => e
      capture_and_fail(:internal_server_error, e)
    end

    private

    def carry_over_rolls_if_necessary
      # @todo: delegate to roll object
      if pins == PIN[:STRIKE]
        return 2
      elsif pins == PIN[:SPARE]
        return 1
      end

      0
    end

    def create_roll
      Success(Roll.create!(frame: current_frame, pins: numerical_pin_value))
    end

    def current_frame
      @current_frame ||= game.current_frame
    end

    # Process characters and return integer value constant.
    # Otherwise, return the pins digit value.
    def numerical_pin_value
      return MAX_SCORE if pins.upcase == PIN[:STRIKE]
      return remaining_pins if pins == PIN[:SPARE]
      return MIN_SCORE if pins == PIN[:MISS]

      pins.to_i
    end

    # If the rolls count equals the frames max_roll_count
    #   OR the max pin value (Strike) was made on the first roll.
    def mark_as_completed_if_necessary
      current_frame.rolls.count == current_frame.max_roll_count ||
        pins == Roll::PIN_CHARACTERS[:STRIKE]
    end

    # Remaining pins for the spare pin calculation
    def remaining_pins
      current_frame = game.current_frame
      MAX_SCORE - current_frame.rolls.first.pins
    end

    def update_current_frame
      # Update frame attribute score and stateful flags
      current_frame.tap do |f|
        f.score = f.rolls.sum(&:pins)
        f.completed = mark_as_completed_if_necessary
        f.carry_over_rolls = carry_over_rolls_if_necessary
      end

      current_frame.save!

      Success(current_frame.reload)
    end

    # If any previous strikes or spares require a carry_over_score
    # to be applied still, it will be.
    def update_frames_with_carry_over_score
      frames_with_carry_over = game.frames.carry_overable.where.not(id: current_frame.id)

      frames_with_carry_over.each do |f|
        f.update!(score: f.score + numerical_pin_value)
        f.decrement!(:carry_over_rolls)
      end

      Success()
    end
  end
end
