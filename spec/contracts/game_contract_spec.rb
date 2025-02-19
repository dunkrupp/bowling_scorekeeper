# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameContract do
  describe '#call' do
    game = Game.build

    context 'with a valid game' do
      it 'succeeds' do
        result = described_class.new.call(game: game)
        expect(result).to be_success
      end
    end

    context 'with an invalid game' do
      it 'fails if the game is not a Game object' do
        result = described_class.new.call(game: 'not a game')
        expect(result).to be_failure
        expect(result.errors[:game]).to include('invalid game.')
      end

      it 'fails if the game is over' do
        game.completed = true
        result = described_class.new.call(game: game)
        expect(result).to be_failure
        expect(result.errors[:game]).to include('game over man! game over!!')
      end
    end
  end
end
