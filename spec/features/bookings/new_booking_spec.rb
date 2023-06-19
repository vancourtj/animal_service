require "rails_helper"

RSpec.describe "new booking form", type: :feature do
  context "when the form data is valid" do
    it "successfully submits and redirects to the show page" do
      visit "/bookings/new"

      fill_in "First Name", with: "Alexander"
      fill_in "Last Name", with: "Hamilton"
      fill_in "Animal Name", with: "Aaron Bork"
      select("Dog", from: "Animal Type")
      fill_in "Hours Required", with: "4"
      fill_in "Date of Service", with: "01/01/2023"

      click_button "Submit"

      latest_booking = Booking.last

      expect(page).to have_current_path("/bookings/#{latest_booking.id}")
      expect(page).to have_content("Animal service request successfully booked!")

      expect(page).to have_content("Alexander")
      expect(page).to have_content("Hamilton")
      expect(page).to have_content("Aaron Bork")
      expect(page).to have_content("Dog")
      expect(page).to have_content("4")
      expect(page).to have_content("2023-01-01")
      expect(page).to have_content("$60.00")
    end
  end

  context "when the form data is invalid" do
    it "renders an error message" do
      visit "/bookings/new"

      fill_in "First Name", with: "Alexander"
      fill_in "Last Name", with: "Hamilton"
      fill_in "Animal Name", with: "Aaron Bork"
      select("Dog", from: "Animal Type")
      fill_in "Hours Required", with: "12"
      fill_in "Date of Service", with: "01/01/2023"

      click_button "Submit"

      expect(page).to have_content(
        "There was an error booking the service. Please try again or reach out to customer service."
      )
    end
  end
end
