OpenBeerDatabase::Application.routes.draw do
  constraints :subdomain => 'api' do
    namespace :v1, :module => 'Api::V1' do
      resources :beers,   :only => [:index, :destroy]
      resources :brewers, :only => [:index, :create] do
        resources :beers, :only => [:create]
      end
    end
  end
end
