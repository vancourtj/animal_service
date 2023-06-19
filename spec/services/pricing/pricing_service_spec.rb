require "rails_helper"

RSpec.describe Pricing::PricingService do
  describe "#call" do
    subject { described_class.call(type, service_length_hours) }

    context "when type has an hourly rate" do
      let(:type) { "dog" }
      let(:service_length_hours) { 2 }

      it "is successful" do
        expect(subject[:success]).to eq(true)
      end

      it "calculates the price" do
        expect(subject[:result]).to eq(40)
      end
    end

    context "when type does not have an hourly rate" do
      let(:type) { "bird" }
      let(:service_length_hours) { 2 }

      it "is not successful" do
        expect(subject[:success]).to eq(false)
      end

      it "returns an error message" do
        expect(subject[:error]).to eq("Provided type bird does not have a defined hourly rate")
      end
    end
  end
end
