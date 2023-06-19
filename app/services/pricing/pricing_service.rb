# frozen_string_literal: true

module Pricing
  class PricingService < ApplicationService
    BASE_CHARGE = 20

    # dollars per hour for each animal type
    HOURLY_RATE_MAP = {
      "cat" => 5,
      "dog" => 10,
    }.freeze

    def initialize(type, service_length_hours)
      @type = type
      @service_length_hours = service_length_hours
    end

    def call
      if hourly_rate.nil?
        {
          success: false,
          error: "Provided type #{@type} does not have a defined hourly rate"
        }
      else
        {
          success: true,
          result: additional_amount + BASE_CHARGE
        }
      end
    end

    private

    def hourly_rate
      @hourly_rate ||= HOURLY_RATE_MAP[@type]
    end

    def additional_amount
      @additional_amount ||= hourly_rate * @service_length_hours
    end
  end
end
