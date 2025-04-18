# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameJsonSerializer, type: :serializer do
  let(:game) { Game.create }
  let(:serializer) { described_class.new(game) }
  let(:json) { serializer.as_json }

  it 'serializes the id correctly' do
    expect(json[:id]).to eq(game.id)
  end

  it 'serializes the frames' do
    expect(json[:frames].size).to eq(10)
  end
end
