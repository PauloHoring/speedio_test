# frozen_string_literal: true

module Api
  module V1
    class AutomationsController < ApplicationController
      before_action :authenticate_request

      def request_configuration_link
        configuration_link = UnipileService.request_configuration_link(current_user)
        if configuration_link
          render json: { configuration_link: configuration_link }, status: :ok
        else
          render json: { error: 'Failed to generate configuration link' }, status: :unprocessable_entity
        end
      end
    end
  end
end
