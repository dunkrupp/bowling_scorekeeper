# frozen_string_literal: true

module Games
  class Create < BaseOperation
    def perform
      Success(Game.create!)
    rescue ActiveRecord::RecordInvalid => e
      capture_and_fail(:creation_error, e)
    end
  end
end
