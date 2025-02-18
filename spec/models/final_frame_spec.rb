# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FinalFrame, type: :model do
  it 'has the correct default frame_number' do
    final_frame = FinalFrame.build
    expect(final_frame.frame_number).to eq(10)
  end

  it 'validates the number of rolls' do
    final_frame = FinalFrame.build(score: 30)
    4.times { final_frame.rolls << Roll.build }
    expect(final_frame).not_to be_valid
    expect(final_frame.errors[:rolls]).to include('cannot have more than 3 rolls')
  end
end
