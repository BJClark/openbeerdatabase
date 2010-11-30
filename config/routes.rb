OpenBeerDatabase::Application.routes.draw do
  constraints :subdomain => 'api' do
    namespace :v1, :module => 'Api::V1' do
      resources :beers,     :only => [:index, :show, :create, :destroy]
      resources :breweries, :only => [:index, :create, :destroy]
    end
  end
end
