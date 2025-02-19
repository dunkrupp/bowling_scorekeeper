# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FrameJsonSerializer, type: :serializer do
  let(:frame) { Frame.create(game: Game.create, frame_number: 1, score: 10, completed: true, carry_over_rolls: 2) }
  let(:serializer) { described_class.new(frame) }
  let(:json) { serializer.as_json }

  it 'serializes the frame_number correctly' do
    expect(json[:frame_number]).to eq(1)
  end

  it 'serializes the score correctly' do
    expect(json[:score]).to eq(10)
  end

  it 'serializes the completed correctly' do
    expect(json[:completed]).to eq(true)
  end

  it 'serializes the carry_over_rolls correctly' do
    expect(json[:carry_over_rolls]).to eq(2)
  end

  it 'serializes the rolls' do
    Roll.create(frame:, pins: 5)
    Roll.create(frame:, pins: 5)

    expect(json[:rolls].size).to eq(2)
  end
end
