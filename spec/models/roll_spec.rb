# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Roll do
  describe 'associations' do
    it 'belongs to a frame' do
      association = described_class.reflect_on_association(:frame)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    it 'validates numericality of pins' do
      roll = Roll.new(pins: -1)
      expect(roll).not_to be_valid
      expect(roll.errors[:pins]).to include('must be greater than or equal to 0')

      roll.pins = 11
      expect(roll).not_to be_valid
      expect(roll.errors[:pins]).to include('must be less than or equal to 10')
    end
  end

  describe 'constants' do
    it 'defines PIN_CHARACTERS correctly' do
      expect(Roll::PIN_CHARACTERS).to eq({ STRIKE: 'X', SPARE: '/', MISS: '-' })
    end

    it 'defines ACCEPTABLE_PIN_CHARACTERS correctly' do
      expect(Roll::ACCEPTABLE_PIN_CHARACTERS).to eq(%w[X / -])
    end

    it 'defines ACCEPTABLE_PIN_DIGITS correctly' do
      expect(Roll::ACCEPTABLE_PIN_DIGITS).to eq(%w[0 1 2 3 4 5 6 7 8 9 10])
    end

    it 'defines ACCEPTABLE_PIN_VALUES correctly' do
      expect(Roll::ACCEPTABLE_PIN_VALUES).to eq(%w[0 1 2 3 4 5 6 7 8 9 10 X / -])
    end
  end
end
# rubocop:enable Metrics/BlockLength
