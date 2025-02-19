# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RollJsonSerializer, type: :serializer do
  let(:frame) { Frame.create!(game: Game.create!, frame_number: 1) }
  let(:roll) { Roll.create!(frame:, pins: 5) }
  let(:serializer) { described_class.new(roll) }
  let(:json) { serializer.as_json }

  it 'serializes the pins correctly for a regular roll' do
    expect(json[:pins]).to eq('5')
  end

  it 'serializes the pins correctly for a strike' do
    roll.update!(pins: 10)
    expect(json[:pins]).to eq('X')
  end

  it 'serializes the pins correctly for a miss' do
    roll.update!(pins: 0)
    expect(json[:pins]).to eq('-')
  end

  it 'serializes the pins correctly for a spare' do
    frame.update!(score: 10)
    roll.update!(pins: 5)
    expect(json[:pins]).to eq('/')
  end
end
