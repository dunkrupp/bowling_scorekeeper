# frozen_string_literal: true

module Api
  module V1
    class GamesController < ::Api::BaseController
      attr_reader :game

      before_action :game_exists?, only: [:roll]
      before_action :validate_params, only: [:roll]

      schemas[:roll] = Dry::Schema.Params do
        required(:id).filled(:integer)
        required(:pins).filled(:string)
      end

      def create
        created(Game.create!)
      end

      def roll
        result = Rolls::Record.new.call(game: game, pins: pins)
        return bad_request(result.failure) unless result.success?

        created(result.value!)
      end

      private

      def game
        @game ||= Game.includes(frames: :rolls).find(safe_params[:id])
      end

      def game_exists?
        not_found unless game.present?
      end

      def pins
        safe_params[:pins]
      end

      def serializer
        GameJsonSerializer
      end

      def validate_params
        result = GameContract.new.call(game:)
        return bad_request(result.errors.to_h) if result.failure?

        result = RollContract.new(game:).call(pins: pins)
        bad_request(result.errors.to_h) if result.failure?
      end
    end
  end
end
