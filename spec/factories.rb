Factory.define :beer do |beer|
  beer.association(:brewery)
  beer.association(:user)
  beer.name        { "Strawberry Harvest" }
  beer.description { "Strawberry Harvest Lager is a wheat beer made with real Louisiana strawberries." }
  beer.abv         { 4.2 }
end

Factory.define :brewery do |brewery|
  brewery.association(:user)
  brewery.name { "Abita" }
end

Factory.define :user do |user|
end
