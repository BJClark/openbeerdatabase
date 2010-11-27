OpenBeerDatabase::Application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :beers, :only => [:create]
    end
  end
end
