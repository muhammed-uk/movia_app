Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :bookings, only: %i[create show index]
      resources :movies
      resources :shows, only: %i[show index]
    end
  end

  match '(/)*path',
        to: proc { [405, {}, []] },
        via: %i[get post put patch delete]
end
