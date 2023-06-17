class BookingsController < ApplicationController
  def index
    @bookings = Booking.order(created_at: :desc)
  end

  def show
    @booking = Booking.find(params[:id])
  end

  def new
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(booking_params)

    if @booking.save
      flash[:success] = "Animal service request successfully booked!"
      redirect_to booking_path(@booking)
    else
      flash[:danger] = "There was an error booking the service. Please try again or reach out to customer service."
      render :new, status: :unprocessable_entity
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:client_first_name, :client_last_name, :animal_name, :animal_type,
                                    :service_length_hours, :service_date)
  end
end
