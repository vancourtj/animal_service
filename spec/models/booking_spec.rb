require "rails_helper"

RSpec.describe Booking, type: :model do
  describe "validations" do
    it { should validate_presence_of(:client_first_name) }
    it { should validate_presence_of(:client_last_name) }
    it { should validate_presence_of(:animal_name) }
    it { should validate_presence_of(:service_length_hours) }
    it { should validate_numericality_of(:service_length_hours).only_integer }
    it { should validate_numericality_of(:service_length_hours).is_in(2..8) }
    it { should validate_presence_of(:animal_type) }
    it {
      should define_enum_for(:animal_type)
        .with_values(Booking::ANIMAL_TYPES.zip(Booking::ANIMAL_TYPES.map(&:titleize)).to_h)
        .backed_by_column_of_type(:string)
    }
    it { should validate_presence_of(:service_date) }
  end

  describe "price" do
    let(:params) do
      {
        client_first_name: "Alexander",
        client_last_name: "Hamilton",
        animal_name: "Aaron Bork",
        animal_type: "dog",
        service_length_hours: 4,
        service_date: Date.current,
      }
    end

    it "defaults the price to 0 on build" do
      instance = Booking.new(params)

      expect(instance.price.amount).to eq(0)
    end

    context "on save" do
      context "Pricing::PricingService is successful" do
        it "sets price as the result" do
          expect(Pricing::PricingService)
            .to receive(:call)
            .with(params[:animal_type], params[:service_length_hours])
            .and_return({ success: true, result: 10 })

          instance = Booking.new(params)

          instance.save

          expect(instance.reload.price.amount).to eq(10)
        end
      end

      context "Pricing::PricingService is not successful" do
        it "does not update the price" do
          expect(Pricing::PricingService)
            .to receive(:call).with(params[:animal_type], params[:service_length_hours])
                              .and_return({ success: false, result: 10 })

          instance = Booking.new(params)

          instance.save

          expect(instance.reload.price.amount).to eq(0)
        end
      end
    end
  end
end
