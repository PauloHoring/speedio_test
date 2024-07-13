# frozen_string_literal: true

class Company
  include Mongoid::Document
  include Mongoid::Timestamps
  field :cnpj, type: String
  field :name, type: String
  field :decisor, type: Hash

  belongs_to :user
  has_many :automations
end
