# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Rolls::RecordEtAl do
  let(:game) { Game.create! }

  describe '#call' do
    context 'with valid input' do
      it 'creates a new roll with the correct pin value' do
        expect do
          described_class.new.call(game:, pins: 'X')
        end.to change(Roll, :count).by(1)
        expect(Roll.last.pins).to eq(10)
      end

      it 'updates the current frame with the correct score and completion status' do
        first_roll_result = described_class.new.call(game:, pins: '5')
        expect(first_roll_result).to be_success
        expect(game.current_frame.score).to eq(5)
        expect(game.current_frame.completed).to be_falsey

        second_roll_result = described_class.new.call(game:, pins: '3')
        expect(second_roll_result).to be_success
        frame = game.frames.first
        expect(frame.score).to eq(8)
        expect(frame.completed).to be_truthy
      end

      it 'handles strikes correctly' do
        expect do
          described_class.new.call(game:, pins: 'X')
        end.to change(Roll, :count).by(1)
        expect(Roll.last.pins).to eq(10)
        frame = game.frames.first
        expect(frame.score).to eq(10)
        expect(frame.completed).to be_truthy
        expect(frame.carry_over_rolls).to eq(2)
      end

      it 'handles spares correctly' do
        described_class.new.call(game:, pins: '5')
        described_class.new.call(game:, pins: '/')
        frame = game.frames.first
        expect(frame.score).to eq(10)
        expect(frame.completed).to be_truthy
        expect(frame.carry_over_rolls).to eq(1)
      end

      it 'handles misses correctly' do
        expect do
          described_class.new.call(game:, pins: '-')
        end.to change(Roll, :count).by(1)
        expect(Roll.last.pins).to eq(0)
      end

      it 'updates previous frames with carry-over scores' do
        described_class.new.call(game:, pins: 'X')
        described_class.new.call(game:, pins: '5')
        frame = game.frames.first
        expect(frame.reload.score).to eq(15)
        expect(frame.carry_over_rolls).to eq(1)
      end

      it 'returns a successful result' do
        result = described_class.new.call(game:, pins: '5')
        expect(result).to be_success
        expect(result.value!).to eq(game)
      end
    end

    context 'with invalid input' do
      it 'returns a failure result with errors' do
        result = described_class.new.call(game:, pins: '12')
        pp result
        expect(result).to be_failure
        expect(result.failure).to be_a(Symbol)
        expect(result.failure).to be_present
      end
    end

    context 'with an unexpected error' do
      before do
        allow(Roll).to receive(:create!).and_raise(StandardError, 'Some unexpected error')
      end

      it 'captures the error and returns a failure result' do
        result = described_class.new.call(game:, pins: '5')
        expect(result).to be_failure
        expect(result.failure).to be_a(Symbol)
        expect(result.failure).to eq(:internal_server_error)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
