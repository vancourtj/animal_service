FactoryBot.define do
  factory :booking, class: Booking do
    client_first_name { "Alexander" }
    client_last_name { "Hamilton" }
    animal_name { "Aaron Bork" }
    animal_type { "dog" }
    service_length_hours { 4 }
    service_date { Date.current }
  end
end
