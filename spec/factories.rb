Factory.define :beer do |beer|
  beer.association(:user)
  beer.name { 'Strawberry Harvest' }
end

Factory.define :user do |user|
end
