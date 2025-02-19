# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Frame, type: :model do
  game =  Game.build
  frame = Frame.build(completed: false, frame_number: 1, game:, score: 0)

  it 'has a valid factory' do
    expect(frame).to be_valid
  end

  it 'belongs to a game' do
    association = described_class.reflect_on_association(:game)
    expect(association.macro).to eq(:belongs_to)
  end

  it 'has many rolls and they are dependent destroy' do
    association = described_class.reflect_on_association(:rolls)
    expect(association.macro).to eq(:has_many)
    expect(association.options[:dependent]).to eq :destroy
  end

  it 'has the correct default type' do
    expect(frame.type).to eq('Frame')
  end

  describe 'validates' do
    it 'validates presence of frame_number' do
      frame = Frame.new(frame_number: nil)
      expect(frame).to_not be_valid
      expect(frame.errors[:frame_number]).to include('can\'t be blank')
    end

    it 'validates presence of score' do
      frame = Frame.new(score: nil)
      expect(frame).to_not be_valid
      expect(frame.errors[:score]).to include('can\'t be blank')
    end

    it 'validates presence of type' do
      frame = Frame.new(type: nil)
      expect(frame).to_not be_valid
      expect(frame.errors[:type]).to include('can\'t be blank')
    end

    it 'validates numericality of frame_number' do
      frame.frame_number = -1
      expect(frame).not_to be_valid
      expect(frame.errors[:frame_number]).to include('must be between 0 and 10')

      frame.frame_number = 11
      expect(frame).not_to be_valid
      expect(frame.errors[:frame_number]).to include('must be between 0 and 10')
    end

    it 'validates numericality of score' do
      frame.score = -1
      expect(frame).not_to be_valid
      expect(frame.errors[:score].first).to include('must be between 0 and 30')

      frame.score = 31
      expect(frame).not_to be_valid
      expect(frame.errors[:score].first).to include('must be between 0 and 30')
    end

    it 'validates the number of rolls' do
      3.times { frame.rolls << Roll.build(pins: (1..10).to_a.sample) }
      expect(frame).not_to be_valid
      pp frame.errors
      expect(frame.errors[:frames]).to include('cannot have more than 2 rolls')
    end
  end

  describe 'scopes' do
    describe '.completed' do
      final_frame = FinalFrame.create(game:, completed: true)

      it 'returns only FinalFrame records' do
        expect(Frame.completed.last).to eq(final_frame)
      end
    end
  end
end
