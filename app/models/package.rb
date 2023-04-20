# frozen_string_literal: true

class Package < ApplicationRecord
  has_many :prices, dependent: :destroy
  has_many :municipalities

  validates :name, presence: true, uniqueness: true
  validates :price_cents, presence: true

  def price_for(municipality)
    municipalities.find_by_name(municipality)&.price_cents
  end
end
