# frozen_string_literal: true

module Api
  module V1
    class CompaniesController < ApplicationController
      before_action :authenticate_request
      before_action :set_company, only: %i[send_email send_invite send_message]

      def send_email
        email_params = params.require(:email).permit(:message, :to, :programmed_to)
        result = EmailService.new(@company, email_params).process

        render_result(result)
      end

      def send_invite
        invite_params = params.require(:invite).permit(:profile_url, :programmed_to)
        result = LinkedinInviteService.new(@company, invite_params).process

        render_result(result)
      end

      def send_message
        message_params = params.require(:message).permit(:profile_url, :message, :programmed_to)
        result = LinkedinMessageService.new(@company, message_params).process

        render_result(result)
      end

      private

      def set_company
        user = User.find(@current_user)
        @company = user.company
      end

      def render_result(result)
        if result.success?
          render json: { message: result.message }, status: :ok
        else
          render json: { error: result.error, details: result.details }, status: :unprocessable_entity
        end
      end
    end
  end
end
