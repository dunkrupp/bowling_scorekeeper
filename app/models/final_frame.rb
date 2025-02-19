# frozen_string_literal: true

class FinalFrame < Frame
  attribute :frame_number, :integer, default: MAX_FRAME_NUMBER

  def final_frame?
    true
  end

  def max_roll_count
    3
  end
end
