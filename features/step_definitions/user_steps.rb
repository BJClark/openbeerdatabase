Then /^the "([^"]*)" API user should have (\d+) beers?$/ do |token, count|
  User.find_by_token!(token).beers.count.should == count
end

Then /^the "([^"]*)" API user should have (\d+) (?:brewer|breweries)$/ do |token, count|
  User.find_by_token!(token).breweries.count.should == count
end
