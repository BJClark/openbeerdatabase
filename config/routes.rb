OpenBeerDatabase::Application.routes.draw do
  constraints :subdomain => 'api' do
    namespace :v1, :module => 'Api::V1' do
      resources :beers,     :only => [:index, :show, :create, :destroy]
      resources :breweries, :only => [:index, :show, :create, :destroy]
    end
  end

  constraints :subdomain => 'www' do
    root  :to      => redirect { |_, request| "http://#{request.host.sub('www.', '')}" }
    match '/*path' => redirect { |_, request| "http://#{request.host.sub('www.', '')}#{request.path}" }
  end

  constraints(lambda { |request| request.subdomain.blank? }) do
    resources :documentation, :only => [:show]
    resources :users,         :only => [:new]

    root :to => 'Documentation#show', :id => 'overview'
  end
end
