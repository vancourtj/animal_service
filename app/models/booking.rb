# frozen_string_literal: true

class Booking < ApplicationRecord
  ANIMAL_TYPES = %w[cat dog].freeze

  validates :client_first_name, presence: true, length: { maximum: 255 }
  validates :client_last_name, presence: true, length: { maximum: 255 }
  validates :animal_name, presence: true, length: { maximum: 255 }
  validates :service_length_hours, presence: true, numericality: { only_integer: true, in: 2..8 }
  validates :animal_type, presence: true
  validates :service_date, presence: true

  enum animal_type: ANIMAL_TYPES.zip(ANIMAL_TYPES.map(&:titleize)).to_h
  monetize :price_cents

  before_save :calculate_price

  private

  def calculate_price
    pricing = Pricing::PricingService.call(animal_type, service_length_hours)

    if pricing[:success]
      self.price = pricing[:result]
    end
  end
end
