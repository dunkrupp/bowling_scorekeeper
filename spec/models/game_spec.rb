# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Game, type: :model do
  describe 'associations' do
    it 'has many frames' do
      association = described_class.reflect_on_association(:frames)
      expect(association.macro).to eq(:has_many)
    end

    it 'destroys frames when the game is destroyed' do
      game = Game.create
      expect { game.destroy }.to change(Frame, :count).by(-10)
    end
  end

  describe '#create_frames' do
    game = Game.create

    it 'creates 10 frames after game creation' do
      expect(game.frames.count).to eq(10)
    end

    it 'creates 9 regular frames and 1 final frame' do
      expect(game.frames.where(type: 'Frame').count).to eq(9)
      expect(game.frames.where(type: 'FinalFrame').count).to eq(1)
    end

    it 'assigns the correct frame numbers' do
      expect(game.frames.pluck(:frame_number)).to eq((1..10).to_a)
    end
  end

  describe '#current_frame' do
    game = Game.create

    context 'when no frames are completed' do
      it 'returns the first frame' do
        expect(game.current_frame.frame_number).to eq(1)
      end
    end

    context 'when some frames are completed' do
      before do
        game.frames.first.update!(completed: true)
      end

      it 'returns the next incomplete frame' do
        expect(game.current_frame.frame_number).to eq(2)
      end
    end

    context 'when all frames are completed' do
      before do
        game.frames.where(type: 'Frame').find_each { |frame| frame.update!(completed: true) }
      end

      it 'returns the last frame' do
        expect(game.current_frame.frame_number).to eq(10)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
