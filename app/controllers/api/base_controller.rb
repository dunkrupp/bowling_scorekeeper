# frozen_string_literal: true

module Api
  # Base controller for API endpoints.
  # Provides common methods and configurations for API controllers.
  class BaseController < ::ApplicationController
    include ::Dry::Monads::Result::Mixin

    private

    # Renders a bad request response with the given message.
    #
    # @param errors [Hash] The error message to include in the response.
    # @return [void]
    def bad_request(errors = { status: 'Bad Request' })
      render json: { errors: }, status: :bad_request
    end

    # Renders a created response with the given JSON data and serializer.
    #
    # @param json [Any] The JSON data to render.
    # @return [void]
    def created(json = {})
      render json:, serializer:, status: :created
    end

    # Renders a not found response with the given message.
    #
    # @param errors [Any] The error message to include in the response.
    # @return [void]
    def not_found(errors = { status: 'Not Found' })
      render json: { errors: }, status: :not_found
    end
  end
end
