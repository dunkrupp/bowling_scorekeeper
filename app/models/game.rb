# frozen_string_literal: true

class Game < ApplicationRecord
  after_create :create_frames
  has_many :frames, dependent: :destroy

  def current_frame
    frames.incomplete.first
  end

  private

  def create_frames
    9.times { |index| frames.create!(frame_number: index + 1, type: Frame::TYPES[:Frame]) }
    frames.create!(frame_number: 10, type: Frame::TYPES[:FinalFrame])
  end
end
