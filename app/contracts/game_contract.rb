# frozen_string_literal: true

class GameContract  < Dry::Validation::Contract
  params do
    required(:game).filled
  end

  rule(:game) do
    key.failure('invalid game.') unless value.is_a?(Game)
    key.failure('game over man! game over!!') unless value.respond_to?(:incomplete?) && value.incomplete?
  end
end
