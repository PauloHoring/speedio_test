# frozen_string_literal: true

class Automation
  include Mongoid::Document
  include Mongoid::Timestamps
  field :type, type: String
  field :message, type: String
  field :programmed_to, type: Time
  field :sent_at, type: Time

  belongs_to :company

  validates :type, inclusion: { in: %w[linkedin_connection linkedin_message email] }
  validates :message, presence: true, unless: -> { type == 'linkedin_connection' }
  validates :programmed_to, presence: true
end
