# frozen_string_literal: true

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :email, type: String
  field :otp_code, type: String
  field :otp_code_expires_at, type: Time
  field :unipile_email_account_id, type: String
  field :unipile_linkedin_account_id, type: String

  has_one :company

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }

  validates :name, presence: true
end
