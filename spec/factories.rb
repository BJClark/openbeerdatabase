Factory.define :beer do |beer|
  beer.association(:brewer)
  beer.association(:user)
  beer.name { 'Strawberry Harvest' }
end

Factory.define :brewer do |brewer|
  brewer.association(:user)
  brewer.name { 'Abita' }
end

Factory.define :user do |user|
end
