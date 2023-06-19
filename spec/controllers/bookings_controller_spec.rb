require "rails_helper"

RSpec.describe BookingsController, type: :controller do
  describe "#index" do
    context "when there are no Bookings" do
      render_views

      it "renders the no saved bookings text" do
        get :index

        expect(response.body).to include("There are no saved Bookings")
      end
    end

    context "when there are Bookings" do
      it "orders them by created_at desc" do
        booking1 = create(:booking)
        booking2 = create(:booking)

        get :index

        expect(assigns(:bookings).first).to eq(booking2)
        expect(assigns(:bookings).last).to eq(booking1)
      end
    end
  end

  describe "#create" do
    context "when the params are valid" do
      let(:params) do
        {
          booking: {
            client_first_name: "Alexander",
            client_last_name: "Hamilton",
            animal_name: "Aaron Bork",
            animal_type: "dog",
            service_length_hours: 4,
            service_date: Date.current,
          }
        }
      end

      it "creates a new Booking" do
        expect { post :create, params: params }.to change(Booking, :count).by(1)

        expect(Booking.last.attributes.except("id", "created_at", "updated_at",
                                              "price_cents")).to eq(params[:booking].with_indifferent_access)
      end

      it "redirects to the show page" do
        post :create, params: params

        expect(response).to redirect_to(booking_path(Booking.last))
      end

      context "flash message" do
        before { post :create, params: params }

        it { should set_flash[:success].to("Animal service request successfully booked!") }
      end
    end

    context "when the params are invalid" do
      let(:params) do
        {
          booking: {
            client_first_name: "Alexander",
            client_last_name: "Hamilton",
            animal_name: "Aaron Bork",
            animal_type: "dog",
            service_length_hours: 1,
            service_date: Date.current,
          }
        }
      end

      it "does not create a new Booking" do
        expect { post :create, params: params }.to change(Booking, :count).by(0)
      end

      it "returns a 422" do
        post :create, params: params

        expect(response.code).to eq("422")
      end

      context "flash message" do
        before { post :create, params: params }

        it {
          should set_flash[:danger].to(
            "There was an error booking the service. Please try again or reach out to customer service."
          )
        }
      end
    end
  end
end
