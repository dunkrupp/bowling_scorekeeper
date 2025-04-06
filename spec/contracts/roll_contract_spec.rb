# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe RollContract do
  describe '#call' do
    game = Game.create!

    describe '#call' do
      context 'with valid input' do
        it 'succeeds with valid numeric pins' do
          result = described_class.new(game:).call({ pins: '5' })
          expect(result).to be_success
        end

        it 'succeeds with a valid strike symbol on the first roll' do
          result = described_class.new(game:).call({ pins: 'X' })
          expect(result).to be_success
        end

        it 'succeeds with a valid spare symbol on the second roll' do
          game.current_frame.rolls.create!(pins: 5)
          result = described_class.new(game:).call({ pins: '/' })
          expect(result).to be_success
        end

        it 'succeeds with a valid miss symbol' do
          result = described_class.new(game:).call({ pins: '-' })
          expect(result).to be_success
        end
      end

      context 'with invalid input' do
        it 'fails with an invalid pin value' do
          result = described_class.new(game:).call({ pins: '12' })
          expect(result).to be_failure
          expect(result.errors[:pins]).to include('must be a valid symbol (X, /, -) or a number between 0 and 10')
        end

        it 'fails with a spare symbol on the first roll' do
          result = described_class.new(game:).call({ pins: '/' })
          expect(result).to be_failure
          expect(result.errors[:pins]).to include('cannot be a spare on the first roll')
        end

        it 'fails with a strike symbol on the second roll' do
          game.current_frame.rolls.create!(pins: 5)
          result = described_class.new(game:).call({ pins: 'X' })
          expect(result).to be_failure
          expect(result.errors[:pins]).to include('cannot be a strike on the second roll')
        end
      end
    end

    describe '#invalid_frame_score?' do
      let(:game) { Game.create! }
      let(:frame) { Frame.create!(game:) }
      let(:roll) { Roll.create!(frame:, pins: '1') }

      context 'with a valid score' do
        it 'returns successfully' do
          expect(described_class.new(game:).call({ pins: '1' })).to be_success
        end
      end
    end

    describe '#invalid_final_frame_score?' do
      context 'with a valid score' do
        it 'returns successfully' do
          # games done
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
