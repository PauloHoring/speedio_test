# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_request, except: [:create]
  attr_reader :current_user

  private

  def authenticate_request
    token = request.headers['Authorization'].split(' ').last
    decoded_token = AuthenticateService::JwtService.decode(token)
    @current_user = User.find(decoded_token[:user])
  rescue StandardError
    render json: { error: 'Not Authorized' }, status: 401
  end
end
