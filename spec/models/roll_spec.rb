# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Roll, type: :model do
  it 'belongs to a frame' do
    association = described_class.reflect_on_association(:frame)
    expect(association.macro).to eq(:belongs_to)
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
end
