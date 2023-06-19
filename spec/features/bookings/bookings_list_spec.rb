require "rails_helper"

RSpec.describe "bookings list", type: :feature do
  context "when at least one booking exists" do
    before do
      create(:booking, client_first_name: "Original")
      create(:booking, client_first_name: "New")
    end

    it "has an entry for all bookings" do
      visit "/bookings"

      expect(page).to have_content("Original")
      expect(page).to have_content("New")
    end

    it "has the correct headers" do
      visit "/bookings"

      expect(page).to have_content("First Name")
      expect(page).to have_content("Last Name")
      expect(page).to have_content("Animal Name")
      expect(page).to have_content("Animal Type")
      expect(page).to have_content("Hours Requested")
      expect(page).to have_content("Service Date")
      expect(page).to have_content("Price")
    end

    it "links to the show page when first name is clicked" do
      visit "/bookings"

      click_link("Original")

      original = Booking.find_by(client_first_name: "Original")

      expect(page).to have_current_path("/bookings/#{original.id}")
    end
  end

  context "when there are no bookings" do
    it "shows the no bookings text" do
      visit "/bookings"

      expect(page).to have_content("There are no saved Bookings")
    end
  end
end
