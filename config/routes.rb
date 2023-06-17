Rails.application.routes.draw do
  resources :bookings, only: %i[index show new create]

  root to: "pages#home"
end
