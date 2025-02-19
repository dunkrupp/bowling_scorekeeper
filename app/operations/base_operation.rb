# frozen_string_literal: true

class BaseOperation
  include Dry::Monads[:do, :result]

  private

  # Logs the message to +Rails.logger+ and returns +Failure(message)+
  #
  # @param [String|Symbol] message
  # @param [Exception] exception
  def capture_and_fail(message, exception)
    Rails.logger.error(exception.message)
    Failure(message)
  end
end
