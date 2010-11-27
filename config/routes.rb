OpenBeerDatabase::Application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :beers, :only => [:index, :create]
    end
  end
end
