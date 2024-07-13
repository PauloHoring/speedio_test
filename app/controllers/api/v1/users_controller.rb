# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate_request, only: %i[register login auth]
      include OtpHelper

      def register
        user = User.new(user_params)
        if user.save
          create_company(user)

          render json: { message: 'User created!' }, status: :created
        else
          render json: { message: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def login
        user = User.find_by(email: params[:email])

        if user
          otp = generate_otp
          user.update(otp_code: otp, otp_code_expires_at: Time.now + 5.minutes)

          render json: { message: 'OTP generated.', otp: otp }, status: :ok
        else
          render json: { error: 'User not found' }, status: :not_found
        end
      end

      def auth
        user = User.find_by(email: params[:email])
        if user && verify_otp(user, params[:otp])
          token = ::AuthenticateService::JwtService.encode({ user: user.id })
          render json: { token: token }, status: :ok
        else
          render json: { error: 'Invalid email or OTP' }, status: :unauthorized
        end
      end

      def config
        user = User.find(@current_user)

        if user.update(config_params)
          render json: { message: 'User configuration updated successfully' }, status: :ok
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :email)
      end

      def config_params
        params.require(:user).permit(:unipile_email_account_id, :unipile_linkedin_account_id)
      end

      def create_company(user)
        company = Company.create(user: user, name: "#{user.name}'s Company")

        create_default_automations(company)
      end

      def create_default_automations(company)
        Automation.create([
                            {
                              company: company,
                              type: 'linkedin_connection',
                              programmed_to: Time.now
                            },
                            {
                              company: company,
                              type: 'linkedin_message',
                              message: 'Hello! Id like to connect with you.',
                              programmed_to: Time.now + 1.hour
                            },
                            {
                              company: company,
                              type: 'email',
                              message: 'Hello! I hope this email finds you well.',
                              programmed_to: Time.now + 2.hours
                            }
                          ])
      end
    end
  end
end
