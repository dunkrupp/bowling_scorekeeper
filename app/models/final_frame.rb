# frozen_string_literal: true

class FinalFrame < Frame
  MAX_ROLLS_PER_FRAME = 3

  attribute :frame_number, :integer, default: 10

  private

  def max_roll_count
    3
  end
end
