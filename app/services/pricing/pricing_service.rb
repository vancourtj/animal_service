# frozen_string_literal: true

module Pricing
  class PricingService < ApplicationService
    BASE_CHARGE = 20

    HOURLY_RATE_MAP = {
      "cat" => 5,
      "dog" => 10,
    }.freeze

    def initialize(type, service_length_hours)
      @type = type
      @service_length_hours = service_length_hours
    end

    def call
      additional_amount + BASE_CHARGE
    end

    private

    def hourly_rate
      @hourly_rate ||= HOURLY_RATE_MAP[@type] || 0
    end

    def additional_amount
      @additional_amount ||= hourly_rate * @service_length_hours
    end
  end
end
