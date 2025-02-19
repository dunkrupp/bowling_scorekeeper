# frozen_string_literal: true

class Game < ApplicationRecord
  after_create :create_frames

  attribute :completed, :boolean, default: false
  attribute :created_at, :datetime
  attribute :updated_at, :datetime

  has_many :frames, dependent: :destroy

  def current_frame
    frames.incomplete.first || frames.last
  end

  def incomplete?
    !completed?
  end

  private

  def create_frames
    9.times { |index| frames.create!(frame_number: index + 1, type: Frame::TYPES[:Frame]) }
    frames.create!(frame_number: 10, type: Frame::TYPES[:FinalFrame])
  end
end
