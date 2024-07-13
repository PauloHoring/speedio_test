# frozen_string_literal: true

module OtpHelper
  def generate_otp
    SecureRandom.random_number(100_000..999_999).to_s
  end

  def verify_otp(user, code)
    return false if user.otp_code.nil? || user.otp_code_expires_at.nil? || Time.now > user.otp_code_expires_at

    user.otp_code == code
  end
end
