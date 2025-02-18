# frozen_string_literal: true

class Frame < ApplicationRecord
  MIN_FRAME_NUMBER = 0
  MAX_FRAME_NUMBER = 10
  MIN_SCORE_PER_FRAME = 0
  MAX_SCORE_PER_FRAME = 30

  TYPES = {
    Frame: 'Frame',
    FinalFrame: 'FinalFrame'
  }.freeze

  attribute :completed, :boolean, default: false
  attribute :frame_number, :integer
  attribute :score, :integer, default: 0
  attribute :type, :string, default: -> { TYPES[:Frame] }

  belongs_to :game
  has_many :rolls, dependent: :destroy, validate: true

  scope :completed, -> { where(completed: true) }
  scope :incomplete, -> { where(completed: false) }

  scope :final_frame, -> { where(type: TYPES[:FinalFrame]) }

  validate :validate_roll_count
  validates :frame_number, :score, :type,
            presence: true
  validates :frame_number, numericality: {
    greater_than_or_equal_to: MIN_FRAME_NUMBER,
    less_than_or_equal_to: MAX_FRAME_NUMBER
  }
  validates :score, numericality: {
    greater_than_or_equal_to: MIN_SCORE_PER_FRAME,
    less_than_or_equal_to: MAX_SCORE_PER_FRAME,
    message: 'Score must be between 0 and 30'
  }

  private

  def max_roll_count
    2
  end

  def validate_roll_count
    errors.add(:rolls, "cannot have more than #{max_roll_count} rolls") if rolls.size > max_roll_count
  end
end
