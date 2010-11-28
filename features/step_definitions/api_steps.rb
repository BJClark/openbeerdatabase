# Request

When /^I send an API GET request to (.*)$/ do |path|
  get "http://api.openbeerdatabase.local#{path}"
end

When /^I send an API POST request to (.*)$/ do |path, body|
  post "http://api.openbeerdatabase.local#{path}", body, { 'CONTENT_TYPE' => 'application/json' }
end

When /^I send an API DELETE request to (.*)$/ do |path|
  delete "http://api.openbeerdatabase.local#{path}"
end


# Response

Then /^I should receive a (\d+) response$/ do |status|
  response.status.should == status
end

Then /^I should see the following JSON response$/ do |string|
  expected = JSON.parse(string)
  actual   = JSON.parse(response.body)
  actual.should == expected
end


# Beer

When /^I create the following beers? via the API using the "([^"]*)" token:$/ do |token, table|
  table.hashes.each do |hash|
    When %{I send an API POST request to /v1/beers.json?token=#{token}}, { :beer => hash }.to_json
  end
end


# Brewer

When /^I create the following brewers? via the API using the "([^"]*)" token:$/ do |token, table|
  table.hashes.each do |hash|
    When %{I send an API POST request to /v1/brewers.json?token=#{token}}, { :brewer => hash }.to_json
  end
end
