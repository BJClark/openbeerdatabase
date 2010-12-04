OpenBeerDatabase::Application.routes.draw do
  constraints :subdomain => 'api' do
    namespace :v1, :module => 'Api::V1' do
      resources :beers,     :only => [:index, :show, :create, :destroy]
      resources :breweries, :only => [:index, :show, :create, :destroy]
    end
  end

  constraints(lambda { |request| request.subdomain.blank? || request.subdomain == 'www' }) do
    resources :documentation, :only => [:show]
    resources :users,         :only => [:new]

    root :to => 'Documentation#show', :id => 'overview'
  end
end
