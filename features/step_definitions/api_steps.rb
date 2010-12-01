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
  JSON.parse(response.body).should == JSON.parse(string)
end


# Beer

When /^I create the following beers? via the API for the "([^"]*)" brewery using the "([^"]*)" token:$/ do |brewery_name, token, table|
  brewery = Brewery.find_by_name!(brewery_name)

  table.hashes.each do |hash|
    When %{I send an API POST request to /v1/beers.json?token=#{token}}, {
      :brewery_id => brewery.id,
      :beer       => hash
    }.to_json
  end
end


# Brewery

When /^I create the following (?:brewery|breweries) via the API using the "([^"]*)" token:$/ do |token, table|
  table.hashes.each do |hash|
    When %{I send an API POST request to /v1/breweries.json?token=#{token}}, { :brewery => hash }.to_json
  end
end
