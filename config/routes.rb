OpenBeerDatabase::Application.routes.draw do
  constraints :subdomain => 'api' do
    namespace :v1, :module => 'Api::V1' do
      resources :beers,   :only => [:index, :create, :destroy]
      resources :brewers, :only => [:create]
    end
  end
end
