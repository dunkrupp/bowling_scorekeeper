# frozen_string_literal: true

module Rolls
  class RecordEtAl < BaseOperation
    MIN_SCORE = Roll::MIN_PINS_PER_ROLL
    MAX_SCORE = Roll::MAX_PINS_PER_ROLL
    PIN = Roll::PIN_CHARACTERS

    attr_reader :game, :pins

    # @todo: refactor this to minimize rubocop disables
    # rubocop:disable Metrics/MethodLength
    def call(game:, pins:)
      @game = game
      @pins = pins

      # @todo: these should all be their own operations which we can
      #   chain together using yield and proper Failure() / Success() monads.
      ActiveRecord::Base.transaction do
        create_roll
        update_current_frame
        update_frames_with_carry_over_score
        mark_game_complete
        Success(game.reload)
      end
    rescue StandardError => e
      capture_and_fail(:internal_server_error, e)
    end
    # rubocop:enable Metrics/MethodLength

    private

    def carry_over_rolls_if_necessary
      return 0 if current_frame.final_frame?

      if pins == PIN[:STRIKE]
        return 2
      elsif pins == PIN[:SPARE] || current_frame.rolls.sum(&:pins) == MAX_SCORE
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

    def final_frame_complete?
      current_frame.final_frame? && current_frame.roll_count > 1 &&
        (
          current_frame.roll_sum < MAX_SCORE ||
            current_frame.roll_count == current_frame.max_roll_count
        )
    end

    def normal_frame_complete?
      !current_frame.final_frame? &&
        (
          current_frame.roll_count == current_frame.max_roll_count ||
            pins == PIN[:STRIKE]
        )
    end

    # Process characters and return integer value.
    # Otherwise, return the pins digit value.
    def numerical_pin_value
      return MAX_SCORE if pins.upcase == PIN[:STRIKE]
      return remaining_pins if pins == PIN[:SPARE]
      return MIN_SCORE if pins == PIN[:MISS]

      pins.to_i
    end

    def mark_as_completed_if_necessary
      normal_frame_complete? ||
        final_frame_complete?
    end

    def mark_game_complete
      game.update!(completed: true) if final_frame_complete?
    end

    def remaining_pins
      MAX_SCORE - current_frame.rolls.first.pins
    end

    def strike?
      pins == Roll::PIN_CHARACTERS[:STRIKE]
    end

    def update_current_frame
      current_frame.tap do |f|
        f.score = f.rolls.sum(&:pins)
        f.completed = mark_as_completed_if_necessary
        f.carry_over_rolls = carry_over_rolls_if_necessary
      end
      current_frame.save!
      current_frame.reload
    end

    def update_frames_with_carry_over_score
      frames_with_carry_over = game.frames.carry_overable.where.not(id: current_frame.id)

      frames_with_carry_over.each do |f|
        f.update!(
          score: f.score + numerical_pin_value,
          carry_over_rolls: f.carry_over_rolls - 1
        )
      end
    end
  end
end
